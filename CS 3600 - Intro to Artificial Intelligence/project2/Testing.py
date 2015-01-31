import BinaryCSP

def get_lines(fileName):
    lines = []
    with open(fileName,'r') as readFile:
        for line in readFile:
            lines.append(line)
    return lines


""" Takes a list of lines and creates a CSP representation.
    Format:
    variable values ...
    ...
    0
    binary_constraint_type inputs ...
    ...
    0
    unary_constraint_type inputs ... 
    ... """
def csp_parse(csp_lines):
    i = 0
    variables = []
    domains = []
    while csp_lines[i].strip() != '0':
        line = csp_lines[i].split()
        variables.append(line[0])
        domains.append(set(line[1:]))
        i += 1
    i += 1

    binary_constraints = []
    while csp_lines[i].strip() != '0':
        line = csp_lines[i].split()
        binary_constraints.append(getattr(BinaryCSP, line[0])(*line[1:]))
        i += 1
    i += 1

    unary_constraints = []
    while i < len(csp_lines):
        line = csp_lines[i].split()
        unary_constraints.append(getattr(BinaryCSP, line[0])(*line[1:]))
        i += 1

    return BinaryCSP.ConstraintSatisfactionProblem(variables, domains, binary_constraints, unary_constraints)

""" Takes a list of lines and creates an Assignment representation.
    Format:
    csp_filename
    variable new_domain_values ...
    ...
    0
    variable assigned_value
    ... """
def assignment_parse(assignment_lines):
    csp = None
    with open(assignment_lines[0].strip()) as csp_file:
        csp = csp_parse(csp_file.readlines())
    assignment = BinaryCSP.Assignment(csp)

    i = 1
    while assignment_lines[i].strip() != '0':
        line = assignment_lines[i].split()
        assignment.varDomains[line[0]] = set(line[1:])
        i += 1
    i += 1

    while i < len(assignment_lines):
        line = assignment_lines[i].split()
        assignment.assignedValues[line[0]] = line[1]
        assignment.varDomains[line[0]] = set([line[1]])
        i += 1

    return assignment
