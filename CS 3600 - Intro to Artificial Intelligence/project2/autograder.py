# import sys
import argparse
import BinaryCSP
import traceback
from os import listdir
from Testing import get_lines, csp_parse, assignment_parse

questionValues = {
    'q1': 4,
    'q2': 2,
    'q3': 2,
    'q4': 4,
    'q5': 4,
    'q6': 2
}

""" Runs a single test. Either prints correct or a failure message.
    Returns True if the test passes. ValueError if test does not exist. """
def run_test(test_file_name):
    result = None
    args = []
    hint = None

    try:
        with open(test_file_name) as test_file:
            test_function = getattr(BinaryCSP, test_file.readline().strip())
            for line in test_file:
                line = line.split()
                line_type = line[0]

                if line_type == 'csp':
                    with open(line[1]) as csp_file:
                        args.append(csp_parse(csp_file.readlines()))
                elif line_type == 'assignment':
                    with open(line[1]) as assignment_file:
                        args.append(assignment_parse(assignment_file.readlines()))
                elif line_type == 'function':
                    args.append(getattr(BinaryCSP, line[1]))
                elif line_type == 'constraint':
                    args.append(getattr(BinaryCSP, line[1])(*line[2:]))
                elif line_type == 'boolean':
                    args.append(line[1] == 'True')
                elif line_type == 'hint':
                    hint = ' '.join(line[1:])
                else:
                    args.append(line[1])
    except IOError:
        raise ValueError('Invalid test: %s\n(Tests should normally be specified as \'test_cases\[question]\[test].test\')' % test_file_name)
    except Exception as e:
        print 'An error occured within the autograder: '
        print e

    try:
        result = test_function(*args)
    except Exception, e:
        print
        print 'FAIL:', test_file_name
        print 'Something broke:'
        print traceback.format_exc()
        return False

    try:
        test_local = {'success': False, 'result': result, 'args': args, 'correct': None}
        execfile(test_file_name.replace('.test', '.solution'), {}, test_local)
        correct = test_local['correct']
        success = test_local['success']
    except IOError, e:
        raise ValueError('Invalid solution file: %s' % test_file_name.replace('.test', '.solution'))
    except Exception, e:
        print
        print 'FAIL:', test_file_name
        print 'Solution check failed. Check your return type.'
        print
        return False

    if success:
        print 'PASS:', test_file_name
    else:
        print
        print 'FAIL:', test_file_name
        print 'Your answer:', str(result)
        print 'Correct answer:', str(correct)
        if hint is not None:
            print 'Hint:', hint
        print

    return success


""" Runs every test in a list of tests.
    Prints an error message for invalid tests. """
def run_tests(tests):
    print '____________________________________________________________________'
    print
    all_pass = True
    for test in tests:
        try:
            all_pass = run_test(test) and all_pass
        except ValueError, e:
            print e
    if all_pass:
        print
        print '--------------------------------------------------------------------'
        print 'All tests passed'
        print '--------------------------------------------------------------------'
        print
    else:
        print
        print '--------------------------------------------------------------------'
        print 'Not all tests passed'
        print '--------------------------------------------------------------------'
        print


""" Runs every test for a question. Returns points and possible points.
    ValueError if question does not exist. """
def eval_question(question):
    if question not in questionValues:
        raise ValueError('Invalid question: %s' % question)

    print '____________________________________________________________________'
    print 'Testing question: %s' % question
    print '--------------------------------------------------------------------'
    all_correct = True
    for file_name in [name for name in listdir('test_cases/'+question) if 'test' in name]:
        try:
            all_correct = run_test('test_cases/'+question+'/'+file_name) and all_correct
        except Exception, e:
            print e
            print 

    print '--------------------------------------------------------------------'
    if all_correct:
        print 'All tests passed for question %s' % question
        print '--------------------------------------------------------------------'
        print
        return questionValues[question], questionValues[question]
    print 'Not all tests passed for question %s' % question
    print '--------------------------------------------------------------------'
    print
    return 0, questionValues[question]


""" Runs every question in a list of questions. Sums possible and earned points.
    Prints an error message for invalid questions."""
def run_questions(questions):
    sum_earned = 0
    sum_possible = 0
    for question in questions:
        try:
            points, possible = eval_question(question)
            sum_earned += points
            sum_possible += possible
        except ValueError, e:
            print e
    return (sum_earned, sum_possible)


""" Parses command line arguments. Can run a list of questions and a list of tests.
    Defaults to running all questions and printing the total score. """
def main():
    print
    parser = argparse.ArgumentParser(description='Constraint satisfaction problem autograder')
    parser.add_argument('-q', '--question', action='append', dest='questions')
    parser.add_argument('-t', '--test', action='append', dest='tests')
    args = vars(parser.parse_args())

    if args['tests'] is not None:
        run_tests(args['tests'])
    if args['questions'] is not None:
        run_questions(args['questions'])
    if args['tests'] is None and args['questions'] is None:
        questions = questionValues.keys()
        questions.sort()
        points, possible = run_questions(questions)
        print '--------------------------------------------------------------------'
        print 'Autograder finished. Final score %d/%d'%(points,possible)
        print '--------------------------------------------------------------------'

if __name__=='__main__':
    main()
