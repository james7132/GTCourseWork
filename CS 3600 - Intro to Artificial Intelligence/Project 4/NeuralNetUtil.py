#utility functions for neural net project
import random
def getNNPenData(fileString="datasets/pendigits.txt", limit=100000):
    """
    returns limit # of examples from penDigits file
    """
    examples=[]
    data = open(fileString)
    lineNum = 0
    for line in data:
        inVec = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        outVec = [0,0,0,0,0,0,0,0,0,0]                      #which digit is output
        count=0
        for val in line.split(','):
            if count==16:
                outVec[int(val)] = 1
            else:
                inVec[count] = int(val)/100.0               #need to normalize values for inputs
            count+=1
        examples.append((inVec,outVec))
        lineNum += 1
        if (lineNum >= limit):
            break
    return examples

def getList(num,length):
    list = [0]*length
    list[num-1] = 1
    return list
    
def getNNCarData(fileString ="datasets/car.data.txt", limit=100000 ):
    """
    returns limit # of examples from file passed as string
    """
    examples=[]
    attrValues={}
    data = open(fileString)
    attrs = ['buying','maint','doors','persons','lug_boot','safety']
    attr_values = [['vhigh', 'high', 'med', 'low'],
                 ['vhigh', 'high', 'med', 'low'],
                 ['2','3','4','5more'],
                 ['2','4','more'],
                 ['small', 'med', 'big'],
                 ['high', 'med', 'low']]
    
    attrNNList = [('buying', {'vhigh' : getList(1,4), 'high' : getList(2,4), 'med' : getList(3,4), 'low' : getList(4,4)}),
                 ('maint',{'vhigh' : getList(1,4), 'high' : getList(2,4), 'med' : getList(3,4), 'low' : getList(4,4)}),
                 ('doors',{'2' : getList(1,4), '3' : getList(2,4), '4' : getList(3,4), '5more' : getList(4,4)}),
                 ('persons',{'2' : getList(1,3), '4' : getList(2,3), 'more' : getList(3,3)}),
                 ('lug_boot',{'small' : getList(1,3),'med' : getList(2,3),'big' : getList(3,3)}),
                 ('safety',{'high' : getList(1,3), 'med' : getList(2,3),'low' : getList(3,3)})]

    classNNList = {'unacc' : [1,0,0,0], 'acc' : [0,1,0,0], 'good' : [0,0,1,0], 'vgood' : [0,0,0,1]}
    
    for index in range(len(attrs)):
        attrValues[attrs[index]]=attrNNList[index][1]

    lineNum = 0
    for line in data:
        inVec = []
        outVec = []
        count=0
        for val in line.split(','):
            if count==6:
                outVec = classNNList[val[:val.find('\n')]]
            else:
                inVec.append(attrValues[attrs[count]][val])
            count+=1
        examples.append((inVec,outVec))
        lineNum += 1
        if (lineNum >= limit):
            break
    return examples


def buildExamplesFromPenData(size=10000):
    """
    build Neural-network friendly data struct
            
    pen data format
    16 input(attribute) values from 0 to 100
    10 possible output values, corresponding to a digit from 0 to 9

    """
    if (size != 10000):
        penDataTrainList = getNNPenData("datasets/pendigitsTrain.txt",int(.8*size))
        penDataTestList = getNNPenData("datasets/pendigitsTest.txt",int(.2*size))
    else :    
        penDataTrainList = getNNPenData("datasets/pendigitsTrain.txt")
        penDataTestList = getNNPenData("datasets/pendigitsTest.txt")
    return penDataTrainList, penDataTestList


def buildExamplesFromCarData(size=200):
    """
    build Neural-network friendly data struct
            
    car data format
    | names file (C4.5 format) for car evaluation domain

    | class values - 4 value output vector

    unacc, acc, good, vgood

    | attributes

    buying:   vhigh, high, med, low.
    maint:    vhigh, high, med, low.
    doors:    2, 3, 4, 5more.
    persons:  2, 4, more.
    lug_boot: small, med, big.
    safety:   low, med, high.
    """
    carData = getNNCarData()
    carDataTrainList = []
    for cdRec in carData:
        tmpInVec = []
        for cdInRec in cdRec[0] :
            for val in cdInRec :
                tmpInVec.append(val)
        #print "in :" + str(cdRec) + " in vec : " + str(tmpInVec)
        tmpList = (tmpInVec, cdRec[1])
        carDataTrainList.append(tmpList)
    #print "car data list : " + str(carDataList)
    tests = len(carDataTrainList)-size
    carDataTestList = [carDataTrainList.pop(random.randint(0,tests+size-t-1)) for t in xrange(tests)]
    return carDataTrainList, carDataTestList
    

def buildPotentialHiddenLayers(numIns, numOuts):
    """
    This builds a list of lists of hidden layer layouts
    numIns - number of inputs for data
    some -suggestions- for hidden layers - no more than 2/3 # of input nodes per layer, and
    no more than 2x number of input nodes total (so up to 3 layers of 2/3 # ins max
    """
    resList = []
    tmpList = []
    maxNumNodes = max(numOuts+1, 2 * numIns)
    if (maxNumNodes > 15):
        maxNumNodes = 15

    for lyr1cnt in range(numOuts,maxNumNodes):
        for lyr2cnt in range(numOuts-1,lyr1cnt+1):
            for lyr3cnt in range(numOuts-1,lyr2cnt+1):
                if (lyr2cnt == numOuts-1):
                    lyr2cnt = 0
                
                if (lyr3cnt == numOuts-1):
                    lyr3cnt = 0
                tmpList.append(lyr1cnt)
                tmpList.append(lyr2cnt)
                tmpList.append(lyr3cnt)
                resList.append(tmpList)
                tmpList = []
    return resList
