#!/usr/bin/env python

"""Sample program that uses eqlscript.py

Copyright (C) 2009-2010 by Dell, Inc.

All rights reserved.  This software may not be copied, disclosed, 
transferred, or used except in accordance with a license granted 
by Dell, Inc.  This software embodies proprietary information 
and trade secrets of Dell, Inc. 
"""

import eqlscript
import sys
import getopt
import getpass

def usage (e):
    print """usage: %(pn)s [-?ht] [-g group ] [-a account] [-p password ] -f cli_file | cli_command

 -? | h      : Describes script usage.
 -t          : Use telnet (default: use SSH)
 -g group    : Group IP address or name.
 -a account  : Group account (default grpadmin)
 -p password : Group account password.  If no password is supplied, the script will
               prompt for a password.
 -f cli_file : Full pathname to a file containing a sequence of one or more
               CLI commands for execution.  The File must contain one
               command per line.
 cli_command : CLI command.  See the CLI Reference manual for a description
               of the CLI commands.

example: %(pn)s -g psg_group -a grpadmin -p my_password grpparams show
example: %(pn)s -g psg_group -a grpadmin -p my_password -f cmds.txt
example: echo "pass" | %(pn)s -g psg_group -a grpadmin grpparams show""" % { "pn" : sys.argv[0] }
    sys.exit (e)

if len (sys.argv) < 2:
    usage (1)
    
opts, args = getopt.getopt (sys.argv[1:], "?hdtg:a:p:f:")
group = pwd = fn = None
debug = telnet = False
user = "grpadmin"
for o, v in opts:
    if o in ("-h", "-?"):
        usage (0)
    if o == "-g":
        group = v
    elif o == "-a":
        user = v
    elif o == "-p":
        pwd = v
    elif o == "-f":
        fn = v
    elif o == "-d":
        debug = True
    elif o == "-t":
        telnet = True
        
if user == "root":
    print "Error: username cannot be root"
    sys.exit (1)

if not group or (not fn and not args):
    usage (1)
if not pwd:
    pwd = getpass.getpass ("Password: ")

eqlscript.DEBUG = debug

# Create the session and log in
try:
    session = eqlscript.session (group, user, pwd, telnet)
except eqlscript.ConnectError:
    print "Error connecting to group address", group
    sys.exit (1)
except eqlscript.LoginError:
    print "Error logging in to username", user
    sys.exit (1)
    
# Send the command, if just one, or the string of command from the file
if fn:
    cmds = file (fn, "r")
else:
    cmds = ( " ".join (args), )

for c in cmds:
    if debug:
        print "Issuing command", c
    output = session.cmd (c)
    err = session.err ()
    if err:
        print err
    else:
        print "\n".join (output)

session.logout ()
sys.exit (0)

