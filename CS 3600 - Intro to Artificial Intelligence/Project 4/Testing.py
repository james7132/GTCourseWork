from NeuralNetUtil import buildExamplesFromCarData,buildExamplesFromPenData
from NeuralNet import buildNeuralNet
import cPickle 
from math import pow, sqrt
import sys

def average(list):
    return sum(list)/float(len(list))

def stDeviation(list):
    mean = average(list)
    diffSq = [pow((val-mean),2) for val in list]
    return sqrt(sum(diffSq)/len(list))

penData = buildExamplesFromPenData() 
def testPenData(hiddenLayers = [24]):
    return buildNeuralNet(penData,maxItr = 200, hiddenLayerList =  hiddenLayers)

carData = buildExamplesFromCarData()
def testCarData(hiddenLayers = [16]):
    return buildNeuralNet(carData,maxItr = 200,hiddenLayerList =  hiddenLayers)

if len(sys.argv) < 2:
    nodes = -1
else:
    nodes = int(sys.argv[1])
pen = []
car = []
for i in range(5):
    if nodes >= 0:
        penTest = testPenData([nodes])
    else:
        penTest = testPenData()
    print penTest
    pen.append(penTest[1])

for i in range(5):
    if nodes >= 0:
        carTest = testCarData([nodes])
    else:
        carTest = testCarData()
    print carTest
    car.append(carTest[1])
print "Pen:", pen
print "Max:", max(pen)
print "Min:", min(pen)
print "Average:", average(pen)
print "Std Dev:", stDeviation(pen)

print "Car:", car
print "Max: ", max(car)
print "Min:", min(car)
print "Average:", average(car)
print "Std Dev:", stDeviation(car)
