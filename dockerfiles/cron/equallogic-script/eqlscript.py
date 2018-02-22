#!/usr/bin/env python

"""Module for scripting Dell EqualLogic array management

Copyright (C) 2009-2011 by Dell, Inc.

All rights reserved.  This software may not be copied, disclosed, 
transferred, or used except in accordance with a license granted 
by Dell, Inc.  This software embodies proprietary information 
and trade secrets of Dell, Inc. 
"""

TIMEOUT = 60                      # default timeout to use in various spots
LOGIN_TIMEOUT = 15                # timeout for login sequence
DEBUG = False
# The following "cli-settings" items are set "off" when the script
# session logs in.  You may change this list if needed.  In particular,
# it might be desirable to remove "formatoutput" from this list.
# As written, it will cause some commands, such as "grpparams show" to
# output data as a single column of values, rather than the more
# familiar two column output.  This is a useful default because it
# is easier to parse.  If you want the two-column output instead, remove
# "formatoutput" from the list:
#SETTINGS = ("paging", "confirmation", "events")
SETTINGS = ("paging", "confirmation", "events", "formatoutput")

import os
import sys
import telnetlib
import re
import time
import socket

try:
    import paramiko
    CRYPTO = True
except ImportError:
    CRYPTO = False

class ConnectError (Exception):
    """Exception raised on error connecting to the specified host."""
class LoginError (Exception):
    """Exception raised if login fails (bad username or bad password)."""

class _telnet_session (telnetlib.Telnet, object):
    def __init__ (self, addr, user, pwd):
        try:
            telnetlib.Telnet.__init__ (self, addr)
        except:
            raise ConnectError
        self.write ("\r")
        self.read_until ("login: ")
        self.write (user + "\r")
        self.read_until ("Password:")
        self.write (pwd + "\r")

    def read (self, timeout = TIMEOUT):
        return self.read_very_eager ().replace ("\r", "")

    def read_until (self, expected, timeout = TIMEOUT):
        return telnetlib.Telnet.read_until (self, expected, timeout).replace ("\r", "")

if not CRYPTO:
    class _ssh_session (object):
        def __init__ (self, *args):
            sys.exit (1)
else:
    class _ssh_session (paramiko.Transport):
        def __init__ (self, addr, user, pwd):
            try:
                fam = socket.getaddrinfo (addr, 22)[0][0]
            except socket.gaierror:
                raise ConnectError
            sock = socket.socket (fam, socket.SOCK_STREAM)
            try:
                sock.connect((addr, 22))
                paramiko.Transport.__init__ (self, sock)
            except:
                sock.close ()
                raise ConnectError
            try:
                paramiko.Transport.connect (self, username = user, password = pwd)
            except:
                paramiko.Transport.close (self)
                raise LoginError
            self.channel = self.open_session ()
            self.channel.settimeout (TIMEOUT)
            self.channel.get_pty ()
            self.channel.invoke_shell ()
            self.pending_output = ""
    
        def expect (self, relist, timeout = TIMEOUT):
            start = time.time ()
            while True:
                delay = timeout - (time.time () - start)
                if delay < 0:
                    # Time's up
                    retval = (-1, None, self.pending_output)
                    self.pending_output = ""
                    self.channel.settimeout (timeout)
                    return retval
                for i in xrange (len (relist)):
                    r = relist[i]
                    m = re.search (r, self.pending_output)
                    if m:
                        retval = (i, m, self.pending_output[:m.end ()])
                        self.pending_output = self.pending_output[m.end ():]
                        return retval
                self.channel.settimeout (delay)            
                self.pending_output += self.readmore ()
    
        def read_until (self, expected, timeout = TIMEOUT):
            start = time.time ()
            while True:
                delay = timeout - (time.time () - start)
                if delay < 0:
                    # Time's up
                    retval = self.pending_output
                    self.pending_output = ""
                    self.channel.settimeout (timeout)
                    return retval
                i = self.pending_output.find (expected)
                if i >= 0:
                    i += len (expected)
                    retval = self.pending_output[:i]
                    self.pending_output = self.pending_output[i:]
                    return retval
                self.channel.settimeout (delay)            
                self.pending_output += self.readmore ()
        
        def readmore (self):
            if self.channel.recv_ready ():
                retval = self.channel.recv (1000000)
                if not retval:
                    raise EOFError
                return retval.replace ("\r", "")
            return ""
    
        def read(self):
            retval = self.pending_output + self.readmore ()
            self.pending_output = ""
            return retval
        
        def write (self, data):
            self.channel.send (data)
    
_re_prompt = re.compile ("\n(\\S+?)(\\(.+?\\))?>")
_re_errstr = re.compile (r"\s*(%\s)?Error:?")
_re_setting = re.compile (r"(\w+):\s*(\w+)")
_re_loginfail = re.compile (r"Login incorrect", re.I)

class session (object):
    """Class for interacting with a Dell EqualLogic management CLI.

    Object creation parameters:
        addr: IP address of the group
        user: username of account to log in to
        pwd:  password for that account
        telnet: True to use telnet, omit or False for ssh
    """
    def __init__ (self, addr, user, pwd, telnet = False):
        self.logged_in = False
        self.ses = None      # In case constructor fails
        if telnet:
            self.ses = _telnet_session (addr, user, pwd)
        else:
            self.ses = _ssh_session (addr, user, pwd)
        self.lasterr = None
        idx, m, s = self.expect ((_re_loginfail, _re_prompt), LOGIN_TIMEOUT)
        if idx < 1:
            self.ses.close ()
            raise LoginError
        self.prompt = m.group (1)
        if DEBUG:
            print "debug: prompt is", self.prompt
        self.promptre = re.compile ("%s(\\(.+?\\))?>" % self.prompt)
        s = self.cmd ("cli-settings show")
        self.settings = dict ()
        for l in s:
            for m in _re_setting.finditer (l):
                self.settings[m.group (1).lower ()] = m.group (2)
        if DEBUG:
            print "debug: settings are", self.settings
        # Turn some things off, provided this CLI version knows
        # that particular setting, and it isn't already "off"
        for opt in SETTINGS:
            try:
                if self.settings[opt] != "off":
                    self.cmd ("cli-settings %s off" % opt)
            except KeyError:
                pass
        self.logged_in = True
        
    def __del__ (self):
        self.logout ()

    def logout (self):
        """Log out the session.  This is optional; the session will
        be logged out if the object is deleted.  The session object
        is no longer useable after this call.
        """
        if not self.ses:
            return
        if self.logged_in:
            for opt in SETTINGS:
                # Restore things we changed, if the old value wasn't
                # "off" (which is what we would have set it to)
                try:
                    if self.settings[opt] != "off":
                        self.cmd ("cli-settings %s %s" % (opt, self.settings[opt]))
                except KeyError:
                    pass
            self.logged_in = False
        self.ses.close ()

    def cmd (self, data):
        """Send the supplied command and return the resulting output,
        in the form of a list of lines.  This is intended for commands
        that don't do any prompting, i.e., the expected behavior is
        that the command is executed and then the CLI prompt appears again.
        
        A newline is automatically supplied at the end of the command
        so the supplied data has to be a complete command line.
        
        Raises EOFError if disconnected.
        """
        self.write (data + "\r")
        # Split the reply into lines, omitting the first and last line
        # which contain command echo and prompt, respectively.
        idx, m, s = self.expect ((self.promptre,))
        s = s.split ("\n")[1:-1]
        if DEBUG:
            print "debug: cmd reply is", s
        i = 0
        self.lasterr = None
        while i < len (s):
            if _re_errstr.match (s[i]):
                self.lasterr = s[i]
                del s[i]
                break
            i += 1
        return s
        
    def err (self):
        """Return the error message from the most recent operation, or
        None if there was no error.
        """
        return self.lasterr

    def read_until (self, expect, timeout = TIMEOUT):
        """Read output from the session until the supplied string is
        encountered, or the timeout expires.  Return what was received.
        If a match was found, the returned string ends at the match
        and any remaining data remains pending.
        Raises EOFError on disconnect.
        """
        return self.ses.read_until (expect, timeout)

    def read (self):
        """Read available output data from the session.  Return what was
        received, if anything.  Raises EOFError on disconnect.
        """
        return self.ses.read ()

    def write (self, data):
        """Send the supplied data to the session.  Raises EOFError if
        disconnected.  Note that no newline is supplied.
        """
        self.ses.write (data)

    def expect (self, relist, timeout = TIMEOUT):
        """Read output from the session until one of the regular
        expressions in the supplied list matches, or the timeout expires.
        Returns (list index, match object, received string) if
        there is a match, or (-1, None, received string) if no match.
        If a match was found, the returned string ends at the match
        and any remaining data remains pending.
        Raises EOFError on disconnect.
        """
        return self.ses.expect (relist, timeout)
