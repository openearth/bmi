#!/usr/bin/env python

"""
Parse a fortran file and generate BMI functions from templates.

Usage:
  generate-bmi <fortranfile>... [--template=<template-dir>]
"""

import os
import glob
import inspect
import re
import json

from docopt import docopt
import mako.template
import mako.lookup


def main(fortranfiles, templatedir="templates"):
    """read the fortran files, parse them and apply them
    to the templates in templatedir"""


    variable_re = re.compile(r'''
    ^\s*                                                                 # start of the line
    (?P<fortrantype>(character|logical|double\s+precision|integer|real)) # type
    .*                                                                   # anything
    (::)                                                                 # double colon
    \s*                                                                  # possible spaces
    (?P<name>\w[\w\d]*)                                                  # the variable name
    (?P<dimension>([(][:,\w]+[)])?)                                      # dimension
    .*                                                                   # anything
    [!][<]?\s*                                                           # comment
    ([(](?P<altname>[\w/\d-]+)[)])?                                      # alternative name
    \s*                                                                  # space
    [[](?P<unit>[\w/\d-]+)[]]                                            # unit
    \s*                                                                  # space
    (?P<description>.*?)                                                 # description
    \s*                                                                  # space
    ((?P<json>[{].*[}]))                                                 # JSON key-value pairs
    \s*                                                                  # space
    $                                                                    # end of line
    ''',
    re.VERBOSE)

    FORTRANTYPESMAP = {
        'logical': 'bool',
        'character': 'char',
        'double precision': 'double',
        'real': 'float',
        'integer': 'int'
    }

    variables = []
    for fortranfile in fortranfiles:
        with open(fortranfile) as f:
            for line in f.readlines():
                match = variable_re.match(line)
                if match:
                    variable = match.groupdict()
                    if variable['dimension'].strip():
                        variable['rank'] = variable['dimension'].count(',') + 1
                    else:
                        variable['rank'] = 0
                    variable['type'] = FORTRANTYPESMAP[variable['fortrantype']]
                    variable.update(json.loads(variable["json"]))
                    variables.append(variable)

    # Create some extra variables that can be used in the template
    ISOTYPESMAP = {
        'bool': "logical(c_bool)",
        'char': "character(kind=c_char)",
        'double': "real(c_double)",
        'float': "real(c_float)",
        'int': "integer(c_int)"
    }

    def dimstr(shape):
        shapetxt = ",".join(shape)
        if shapetxt:
            return "(" + shapetxt + ")"
        else:
            return ""

    templates = [template
                 for template
                 in os.listdir(templatedir)
                 if template.lower().endswith('*.f90')]

    lookup = mako.lookup.TemplateLookup(directories=[templatedir], module_directory='/tmp/mako_modules')

    for template_name in templates:
        template = lookup.get_template(template_name)
        filename = template_name.replace('.f90', '.inc')
        with open(filename, 'w') as f:
            # You can use all the local variables in the templates
            rendered = template.render(**locals())
            f.write(rendered)

if __name__ == '__main__':
    arguments = docopt(__doc__)
    main(arguments['<fortranfile>'], arguments['--template'] or 'templates')
