#!/usr/bin/env python

"""Installer for eqlscript scripting tools

Copyright (C) 2009-2010 by Dell, Inc.

All rights reserved.  This software may not be copied, disclosed, 
transferred, or used except in accordance with a license granted 
by Dell, Inc.  This software embodies proprietary information 
and trade secrets of Dell, Inc. 
"""

from distutils.core import setup

Copyright = __doc__.split ('\n')[2]
Version = "1.0"
License = '\n'.join (__doc__.split ('\n')[2:])
FullName = "Dell EqualLogic scripting tools"
Name = "eqlscript"
Company = "Dell, Inc."

setup (author = Company,
       author_email = "support@equallogic.com",
       license = License,
       description = FullName,
       name = Name,
       url = "http://www.dell.com/equallogic",
       version = Version,
       py_modules = [ "eqlscript" ],
       scripts = [ "EqlCliExec.py" ]
       )
