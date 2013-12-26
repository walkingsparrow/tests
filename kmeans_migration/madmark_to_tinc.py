import copy, re, sys
import xml.etree.cElementTree as ET

testsuites = []
defaults = {}
algorithm = ""
list_of_vars = []
methods_list = []
base_dir = "/Users/qianh1/workspace/madmark/testspec/"
metadata_file = base_dir + "metadata/algorithmspec.xml"

def print_imports():
    print """from madlib.src.template.madlib_test import MADlibTestCase
from madlib.src.test_utils.utils import unique_string
from madlib.src.test_utils.utils import string_to_array
from madlib.src.test_utils.utils import mean_squared_error
from madlib.src.test_utils.utils import read_sql_result
from madlib.src.test_utils.utils import _get_argument_expansion
from madlib.src.test_utils.utils import relative_mean_squared_error
from madlib.src.test_utils.get_dbsettings import get_schema_testing
import os
import re
import sys"""

def print_separator():
    print """
# ------------------------------------------------------------------------
# ------------------------------------------------------------------------
# ------------------------------------------------------------------------
"""

def val_replace(val):
    if val == "NINFINITY":
        return "'-Infinity'"
    elif val == "+INFINITY":
        return "'Infinity'"
    elif val == "EMPTY":
        return "''"
    elif val == "NULL":
        return "NULL"
    else:
        try:
            return int(val)
        except:
            try:
                return float(val)
            except:
                return "'%s'" % val

def flatten(lst):
    result = []
    for element in lst:
        if hasattr(element, '__iter__'):
            result.extend(flatten(element))
        else:
            result.append(element)
    return result

def mode(lst):
    d = {}
    for element in lst:
        try:
            d[element] += 1
        except(KeyError):
            d[element] = 1

    keys = sorted(d.keys())
    max = d[keys[0]]

    for key in keys[1:]:
        if d[key] > max:
            max = d[key]

    for key in keys:
        if d[key] == max:
            return key
    return None

def parse_testsuites(tree):
    # Append <list_parameters> as lists and <parameters> as values
    # to generate an arg_dict of all the variables
    global testsuites
    global algorithm
    global methods_list
    mts = tree.find("multi_test_suites")
    algorithm = mts.find("algorithm").text
    for testsuite in tree.find("multi_test_suites").findall("test_suite"):
        suite = {}
        #suite["name"] = testsuite.find("name").text
        methods_list.append(testsuite.find("method").find("name").text)
        method = testsuite.find("method")
        params = method.find("parameters")
        for param in params.findall("list_parameter") + params.findall("parameter"):
            varname = param.find("name").text
            if param.tag == "list_parameter":
                vals = []
            for val in param.findall("value"):
                txt = val_replace(val.text)
                if param.tag == "list_parameter":
                    vals.append(txt)
                else:
                    vals = txt
            if type(vals) is list:
                vals = tuple(vals)
            suite[varname] = copy.deepcopy(vals)

        testsuites.append(suite)

def display_testsuites():
    dicts = copy.deepcopy(testsuites)
    for suite in dicts:
        for key in suite:
            if key in defaults:
                if type(suite[key]) is not tuple and suite[key] == defaults[key]:
                    suite[key] = None
                elif type(suite[key]) is tuple and defaults[key] in suite[key]:
                    temp = list(suite[key])
                    temp.remove(defaults[key])
                    suite[key] = tuple(temp)
    display_dict = {}
    for k in set(k for d in dicts for k in d):
        display_dict[k] = list(set([d[k] for d in dicts if k in d]))

    for key in display_dict:
        if type(display_dict[key]) is list:
            display_dict[key] = [x for x in flatten(display_dict[key]) if x != None]

    output = "    arg_dict = {"
    for key in list_of_vars:
        if key in display_dict and display_dict[key]:
            output += "\n        '%s': %s," % (key, sorted(display_dict[key]))
    output += "\n    }"
    print output

def generate_default_dict():
    # Determine whether a default value exists for each variable
    # by collating all the values and counting their occurrences
    global defaults
    distinct = {}
    for suite in testsuites:
        for key in suite:
            if key not in distinct:
                distinct[key] = []
            if type(suite[key]) in (tuple,list):
                distinct[key].extend(flatten(suite[key]))
            else:
                distinct[key].append(suite[key])

    for key in distinct.keys():
        default = mode(distinct[key])
        if default:
            defaults[key] = default
        else:
            defaults[key] = "NULL"

def display_defaults(name):
    print "    schema_testing = get_schema_testing()"
    output = "    %s = {" % name
    # Print values in the same order as in the SQL statement,
    # and print 'NULL' for nonexistent values
    for var in list_of_vars:
        if var not in defaults or defaults[var] == "NULL":
            temp = "'NULL'"
        else:
            temp = defaults[var]

        output += "\n        '%s': %s," % (var, temp)
    output += "\n    }"
    print output

def convert_underscores(string):
    return ''.join(word.capitalize() or '_' for word in string.split('_'))

def get_sql_template():
    sql = ""
    dom = ET.parse(metadata_file).getroot()
    for alg in dom.findall("algorithm"):
        name = alg.find("name").text
        if name == algorithm:
            for method in alg.findall("method"):
                if method.find("name").text in methods_list:
                    sql += method.find("template").text
    return sql

def get_vars(sql):
    global list_of_vars
    temp = re.findall(r'{([^}]*)}', sql)
    # Add each var to the list only once,
    # but don't use a set because we want to preserve ordering
    for item in temp:
        if item not in list_of_vars:
            list_of_vars.append(item)
    if "madlib_schema" in list_of_vars:
        list_of_vars.remove("madlib_schema")

def format_sql_template(sql):
    sql = 'run_sql = """\n' + sql
    lines = sql.split('\n')
    for i, line in enumerate(lines):
        line = re.sub(r',\s*--.*$', r',', line)
        line = re.sub(r'}\s*--.*$', r'}', line)
        line = re.sub(r'^\s*--.*$', r'', line)
        line = re.sub(r'^\s+', r'        ', line)
        line = re.sub(r'^        {', r'            {', line)
        line = re.sub(r"^        '", r"            '", line)
        line = re.sub(r'madlib_schema', r'schema_madlib', line)
        lines[i] = line
    sql = '\n'.join(lines) + '"""'
    sql = re.sub(r'\n\n', r'\n', sql)
    return sql

def generate_test_case(type, sql):
    # Type must be "input" or "output"
    output = "class %s%sTestCase (MADlibTestCase):\n    " % (convert_underscores(algorithm), type.capitalize())
    lines = ['"""', 'Run templated SQL tests', '"""', format_sql_template(sql), 'ans_dir = "expected_%s"' % type]
    lines += ['template_method = "%s_%s_{incr_}"' % (type, algorithm)]
    lines += ['template_doc = "This is for %s tests of %s"' % (type, ' '.join(algorithm.split('_')))]

    output += "\n    ".join(lines)
    print output

def requote_sql(sql):
    global testsuites
    global defaults
    datasets = set()
    strings = set()
    for key in defaults:
        if type(defaults[key]) is str:
            strings.add(key)
            if defaults[key].startswith("'madlibtestdata"):
                datasets.add(key)
                defaults[key] = "'" + defaults[key][16:]
    for dict in testsuites:
        for key in dict:
            if type(dict[key]) is str:
                strings.add(key)
                if dict[key].startswith("'madlibtestdata"):
                    datasets.add(key)
                    dict[key] = "'" + dict[key][16:]

    for var in strings:
        sql = re.sub(r"{%s}" % var, r"'{%s}'" % var, sql)
    for var in datasets:
        sql = re.sub(r"{%s}" % var, r"{schema_testing}.{%s}" % var, sql)
    return sql

def print_func():
    print """    template = run_sql
    MADlibTestCase.db_settings_["psql_options"] = "-x"

    def validate(self, sql_resultfile, r_answerfile):
        # Code to validate results goes here
        pass"""

def print_template():
    print "    template_vars = _get_argument_expansion(arg_dict, default_arg_dict)"
    print "    template = run_sql"

def create_R_file(input_file):
    slash = input_file.rindex("/")
    dot = input_file.rindex(".")
    filename = "expected_output" + input_file[slash:dot] + ".R"
    out = open(filename, "w")
    output = ""
    for var in list_of_vars:
        output += "## @madlib-param %s\n" % var
    output += """
dat <- get.data(datatable) # input
ans <- get.result.name() # output

#
# Calculations go here
#

con <- file(ans, \"w\")

#
# Output goes here
#
"""
    print >>out, output
    out.close()


def main():
    # Parse command line argument
    input_file = sys.argv[1]
    if not input_file:
        print """Error: No input file specified.
Please give the relative path of the file to be parsed in the following directory:

    %s""" % base_dir
        sys.exit(1)
    # Parse xml file
    def_file = base_dir + input_file
    dom = ET.parse(def_file)
    parse_testsuites(dom.getroot())
    generate_default_dict()
    sql = get_sql_template()
    get_vars(sql)
    sql = requote_sql(sql)
    #create_R_file(input_file)

    # Format output as TINC testfile
    print_imports()
    print_separator()
    generate_test_case("output", sql)
    display_defaults("template_vars")
    print_func()
    print_separator()
    generate_test_case("input", sql)
    display_testsuites()
    display_defaults("default_arg_dict")
    print_template()

if __name__ == "__main__":
    main()

