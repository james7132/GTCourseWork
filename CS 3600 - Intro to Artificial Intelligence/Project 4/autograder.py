import NeuralNetUtil
import NeuralNet
import traceback
import sys
import getopt
from os import listdir
import cPickle

def sameList(list1,list2,floatDif):
    if len(list1)!=len(list2):
        return False
    for index in xrange(len(list1)):
        if isinstance(list1[index],float):
            if abs(list1[index]-list2[index])>floatDif:
                return False
        elif list1[index]!=list2[index]:
            return False
    return True

def copyWeights(nnet1, nnet2):
    for l in xrange(len(nnet1.layers)):
        for n in xrange(len(nnet1.layers[l])):
            nnet1.layers[l][n].weights = nnet2.layers[l][n].weights
            nnet1.layers[l][n].inSize = nnet2.layers[l][n].inSize

def q1Test(testFile):
    if 'sigmoid' in testFile.name and 'Activation' not in testFile.name:
        value = float(testFile.readline().strip())
        sPercep = NeuralNet.Perceptron()
        solution = sPercep.sigmoid(value)
    else:
        testFuncName = testFile.readline().strip()
        getData = getattr(NeuralNetUtil, testFuncName)
        examples, tests = getData()
        testRangeStart = testFile.readline().strip()
        testRangeEnd = testFile.readline().strip()
        testRangeStart = 0 if testRangeStart=='None' else int(testRangeStart)
        testRangeEnd = len(examples) if testRangeEnd=='None' else int(testRangeEnd)
        examples = examples[testRangeStart:testRangeEnd]
        
        if 'feedforward' in testFile.name:
            sNet = NeuralNet.NeuralNet([16,24,10])
            
            file = open('test_cases/nnet')
            net = cPickle.load(file)
            copyWeights(sNet,net)
            
            solution = []
            for example in examples:
                solution.append(sNet.feedForward(example[0]))
        elif 'Activation' in testFile.name:
            file = open('test_cases/percep')
            percep = cPickle.load(file)
            
            sPercep = NeuralNet.Perceptron(inSize = percep.inSize, weights = percep.weights)
            solution = []
            for example in examples:
                solution.append(sPercep.sigmoidActivation(example[0]))
    return solution

def q2Test(testFile):
    if 'sigmoidDeriv' in testFile.name:
        solution = []
        percep = NeuralNet.Perceptron()
        for line in testFile:
            val = float(line)
            solution = percep.sigmoidDeriv(val)
    else:
        testFuncName = testFile.readline().strip()
        getData = getattr(NeuralNetUtil, testFuncName)
        examples, tests = getData()
        testRangeStart = testFile.readline().strip()
        testRangeEnd = testFile.readline().strip()
        testRangeStart = 0 if testRangeStart=='None' else int(testRangeStart)
        testRangeEnd = len(examples) if testRangeEnd=='None' else int(testRangeEnd)
        examples = examples[testRangeStart:testRangeEnd]
        
        file = open('test_cases/percep')
        percep = cPickle.load(file)

        sPercep = NeuralNet.Perceptron(inSize = percep.inSize-1, weights = percep.weights)
        if 'update' in testFile.name:
            solution = []
            for example in examples:
                solution.append(sPercep.updateWeights(example[0],0.1,0.67))
        elif 'sigmoid' in testFile.name:
            solution = []
            for example in examples:
                solution.append(sPercep.sigmoidActivationDeriv(example[0]))
    return solution

def q3Test(testFile,module=NeuralNet):
    testFuncName = testFile.readline().strip()
    getData = getattr(NeuralNetUtil, testFuncName)
    examples, tests = getData()
    testRangeStart = testFile.readline().strip()
    testRangeEnd = testFile.readline().strip()
    testRangeStart = 0 if testRangeStart=='None' else int(testRangeStart)
    testRangeEnd = len(examples) if testRangeEnd=='None' else int(testRangeEnd)
    examples = examples[testRangeStart:testRangeEnd]
    sNet = NeuralNet.NeuralNet([16,24,10])
    
    file = open('test_cases/nnet')
    net = cPickle.load(file)
    copyWeights(sNet,net)
    
    solution = sNet.backPropLearning(examples,0.1)
    return solution[1]

def q4Test(testFile,module=NeuralNet):
    testFuncName = testFile.readline().strip()
    getData = getattr(NeuralNetUtil, testFuncName)
    examples = getData()
    testRangeStart = testFile.readline().strip()
    testRangeEnd = testFile.readline().strip()
    testRangeStart = 0 if testRangeStart=='None' else int(testRangeStart)
    testRangeEnd = len(examples) if testRangeEnd=='None' else int(testRangeEnd)
    examples = (examples[0][testRangeStart:testRangeEnd],examples[1][testRangeStart:testRangeEnd])
    
    alph = float(testFile.readline())
    weight = float(testFile.readline())
    
    file = open('test_cases/nnet')
    net = cPickle.load(file)
    
    sNet = NeuralNet.NeuralNet([16,24,10])
    copyWeights(sNet,net)
    
    solution = NeuralNet.buildNeuralNet(examples, alpha=alph, weightChangeThreshold = weight,startNNet = sNet)
    return solution[1]
  
def getFile(name, q):
    return open('test_cases/'+q+'/'+name)

def runTests(q,points=2):
    total = 0
    possible = 0
    testFunc = globals()[q+'Test']
    correct=False
    print 'Running %s tests\n'%q
    for fileName in [name for name in listdir('test_cases/'+q) if 'test' in name]:
        possible+=1
        print 'Running test %s'%fileName
        
        try:
            solFile = open('test_cases/'+q+'/'+fileName.replace('.test','.solution'))
            solution = solFile.read().split(';')
        except Exception,e:
            print 'No solution file found'
            continue
        
        try:
            result = testFunc(getFile(fileName,q))
            exec(solution[0].strip())
        except Exception,e:
            print 'You broke something:'
            print traceback.format_exc()
            continue
        if correct:
            total+=1
            print 'Correct answer!'
        else:
            print 'Your answer is incorrect'
            print 'Your answer: %s'%str(result)
            print 'Correct answer: %s\n'%str(solution[1].strip())
    
        print '--------------------------------------------------------------------'
    if total==possible:
        print 'All tests passed - score %d/%d'%(points,points)
        print 'Done\n____________________________________________________________________\n'
        return (points,points)
    else:
        print 'Not all tests passed - score 0/%d'%points
        print 'Done\n____________________________________________________________________\n'
        return (0,points)

def makeSolutionsFiles(q, floatDif = 0.000001):
    testFunc = globals()[q+'Test']
    for fileName in [name for name in listdir('test_cases/'+q) if 'test' in name]:
        print 'Creating solution file for test %s'%fileName
        solution = testFunc(getFile(fileName,q))
        solFile = open('test_cases/'+q+'/'+fileName.replace('.test','.solution'),'w')
        if isinstance(solution,float):
            solFile.write('correct=abs(result-%f)<%f;\n%f'%(solution,floatDif,solution))    
        elif isinstance(solution,list):
            solFile.write('correct=sameList(result,%s,%f);\n%s'%(str(solution),floatDif,str(solution)))
        else:
            solFile.write('correct=str(result)=="""%s""";\n%s'%(str(solution),str(solution)))    
        print 'Solution is \n%s\n'%str(solution)

def runTest(test,questions):
    try:
        solFile = open(test.replace('.test','.solution'))
        solution = solFile.read().split(';')
        q = None
        for question in questions:
            if question in test:
                q = question
        testFunc = globals()[q+'Test']
        result = testFunc(open(test))
        correct = False
        exec(solution[0].strip())
        if correct:
            print 'Correct answer!'
        else:
            print 'Your answer is incorrect'
            print 'Your answer: %s'%str(result)
            print 'Correct answer: %s\n'%str(solution[1].strip())
    except Exception,e:
        print 'No solution file found for test %s, or you broke something'%test

def q1Tests():
    return runTests('q1',2)

def q2Tests():
    return runTests('q2',2)

def q3Tests():
    return runTests('q3',4)

def q4Tests():
    return runTests('q4',4)

def makePickledObjects():
    data = NeuralNetUtil.buildExamplesFromPenData() 
    net = NeuralNet.buildNeuralNet(data, weightChangeThreshold=0.00075,hiddenLayerList = [24])[0]
    print net
    f = open('test_cases/nnet','w')
    cPickle.dump(net,f)
    f.close()
    
    f = open('test_cases/percep','w')
    cPickle.dump(net.layers[0][1],f)
    f.close()
help_string = 'Usage: autograder.py [options]\n\
\
Run public tests on student code\n\
\
Options:\n\
  -h, --help            show this help message and exit\n\
  -t RUNTEST, --test=RUNTEST\n\
                        Run one particular test.  Relative to test root.\n\
  -q GRADEQUESTION, --question=GRADEQUESTION\n\
                        Grade one particular question.'

def main():
    args = sys.argv
    questions = ['q1','q2','q3','q4']
    if len(args)==1:
        sumTotal= 0
        sumPossible = 0
        for q in questions:
            func = globals()[q+'Tests']
            total, possible = func()
            sumTotal+=total
            sumPossible+=possible 
        print '\nAutograder finished. Final score %d/%d'%(sumTotal,sumPossible)
    else:
        opts, args = getopt.getopt(args[1:],"q:t:h",["q=","test=","help"])
        for opt, arg in opts:
            if opt=='-q' or opt=='--q':
                if arg in questions:
                    func = globals()[arg+'Tests']
                    func()
            elif opt=='-t' or opt=='--test':
                runTest(arg,questions)
            elif opt=='-h' or opt=='--telp':
                print help_string
                break

if __name__=='__main__':
    #questions = ['q1','q2','q3','q4']
    #for question in questions:
    #    makeSolutionsFiles(question)
    main()
