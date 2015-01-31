import copy
import sys
from datetime import datetime
from math import exp
from random import random, randint, choice

class Perceptron(object):
    """
    Class to represent a single Perceptron in the net.
    """
    def __init__(self, inSize=1, weights=None):
        self.inSize = inSize+1#number of perceptrons feeding into this one; add one for bias
        if weights is None:
            #weights of previous layers into this one, random if passed in as None
            self.weights = [1.0]*self.inSize
            self.setRandomWeights()
        else:
            self.weights = weights
    
    def getWeightedSum(self, inActs):
        """
        Returns the sum of the input weighted by the weights.
        
        Inputs:
            inActs (list<float/int>): input values, same as length as inSize
        Returns:
            float
            The weighted sum
        """
        return sum([inAct*inWt for inAct,inWt in zip(inActs,self.weights)])
    
    def sigmoid(self, value):
        """
        Return the value of a sigmoid function.
        
        Args:
            value (float): the value to get sigmoid for
        Returns:
            float
            The output of the sigmoid function parametrized by 
            the value.
        """
        return 1 / (1 + exp(-value))
      
    def sigmoidActivation(self, inActs):                                       
        """
        Returns the activation value of this Perceptron with the given input.
        Same as rounded g(z) in book.
        Remember to add 1 to the start of inActs for the bias input.
        
        Inputs:
            inActs (list<float/int>): input values, not including bias
        Returns:
            int
            The rounded value of the sigmoid of the weighted input
        """
        inActs = [1.0] + inActs
        return round(self.sigmoid(self.getWeightedSum(inActs)))
        
    def sigmoidDeriv(self, value):
        """
        Return the value of the derivative of a sigmoid function.
        
        Args:
            value (float): the value to get sigmoid for
        Returns:
            float
            The output of the derivative of a sigmoid function
            parametrized by the value.
        """
        return self.sigmoid(value) * (1 - self.sigmoid(value))
        
    def sigmoidActivationDeriv(self, inActs):
        """
        Returns the derivative of the activation of this Perceptron with the
        given input. Same as g'(z) in book (note that this is not rounded.
        Remember to add 1 to the start of inActs for the bias input.
        
        Inputs:
            inActs (list<float/int>): input values, not including bias
        Returns:
            int
            The derivative of the sigmoid of the weighted input
        """
        inActs = [1.0] + inActs
        return self.sigmoidDeriv(self.getWeightedSum(inActs))
    
    def updateWeights(self, inActs, alpha, delta):
        """
        Updates the weights for this Perceptron given the input delta.
        Remember to add 1 to the start of inActs for the bias input.
        
        Inputs:
            inActs (list<float/int>): input values, not including bias
            alpha (float): The learning rate
            delta (float): If this is an output, then g'(z)*error
                           If this is a hidden unit, then the as defined-
                           g'(z)*sum over weight*delta for the next layer
        Returns:
            float
            Return the total modification of all the weights (absolute total)
        """
        totalModification = 0
        inActs = [1.0] + inActs
        for i, weight in enumerate(self.weights):
            change = alpha * delta * inActs[i]
            old = self.weights[i]
            self.weights[i] += change
            totalModification += abs(change)
        return totalModification
            
    def setRandomWeights(self):
        """
        Generates random input weights that vary from -1.0 to 1.0
        """
        for i in range(self.inSize):
            self.weights[i] = (random() + .0001) * (choice([-1,1]))
        
    def __str__(self):
        """ toString """
        outStr = ''
        outStr += 'Perceptron with %d inputs\n'%self.inSize
        outStr += 'Node input weights %s\n'%str(self.weights)
        return outStr

class NeuralNet(object):                                    
    """
    Class to hold the net of perceptrons and implement functions for it.
    """          
    def __init__(self, layerSize):#default 3 layer, 1 percep per layer
        """
        Initiates the NN with the given sizes.
        
        Args:
            layerSize (list<int>): the number of perceptrons in each layer 
        """
        self.layerSize = layerSize #Holds number of inputs and percepetrons in each layer
        self.outputLayer = []
        self.numHiddenLayers = len(layerSize)-2
        self.hiddenLayers = [[] for x in range(self.numHiddenLayers)]
        self.numLayers =  self.numHiddenLayers+1
        
        #build hidden layer(s)        
        for h in range(self.numHiddenLayers):
            for p in range(layerSize[h+1]):
                percep = Perceptron(layerSize[h]) # num of perceps feeding into this one
                self.hiddenLayers[h].append(percep)
 
        #build output layer
        for i in range(layerSize[-1]):
            percep = Perceptron(layerSize[-2]) # num of perceps feeding into this one
            self.outputLayer.append(percep)
            
        #build layers list that holds all layers in order - use this structure
        # to implement back propagation
        self.layers = [self.hiddenLayers[h] for h in xrange(self.numHiddenLayers)] + [self.outputLayer]
  
    def __str__(self):
        """toString"""
        outStr = ''
        outStr +='\n'
        for hiddenIndex in range(self.numHiddenLayers):
            outStr += '\nHidden Layer #%d'%hiddenIndex
            for index in range(len(self.hiddenLayers[hiddenIndex])):
                outStr += 'Percep #%d: %s'%(index,str(self.hiddenLayers[hiddenIndex][index]))
            outStr +='\n'
        for i in range(len(self.outputLayer)):
            outStr += 'Output Percep #%d:%s'%(i,str(self.outputLayer[i]))
        return outStr
    
    def feedForward(self, inActs):
        """
        Propagate input vector forward to calculate outputs.
        
        Args:
            inActs (list<float>): the input to the NN (an example) 
        Returns:
            list<list<float/int>>
            A list of lists. The first list is the input list, and the others are
            lists of the output values 0f all perceptrons in each layer.
        """
        returnList = [inActs]
        currentActs = inActs
        for layer in self.layers:
            nextActs = []
            for node in layer:
                value = node.sigmoidActivation(currentActs)
                nextActs.append(value)
            returnList.append(nextActs)
            currentActs = nextActs
        return returnList
        
    
    def backPropLearning(self, examples, alpha):
        """
        Run a single iteration of backward propagation learning algorithm.
        See the text and slides for pseudo code.
        NOTE : the pseudo code in the book has an error - 
        you should not update the weights while backpropagating; 
        follow the comments below or the description lecture.
        
        Args: 
            examples (list<tuple<list,list>>):for each tuple first element is input(feature) "vector" (list)
                                                             second element is output "vector" (list)
            alpha (float): the alpha to training with
        Returns
           tuple<float,float>
           
           A tuple of averageError and averageWeightChange, to be used as stopping conditions. 
           averageError is the summed error^2/2 of all examples, divided by numExamples*numOutputs.
           averageWeightChange is the summed weight change of all perceptrons, divided by the sum of 
               their input sizes.
        """
        #keep track of output
        averageError = 0
        averageWeightChange = 0
        numWeights = 0
        errorSum = 0
        summedChanges = 0
        for input, expected in examples:#for each example
            
            """YOUR CODE"""
            """Get output of all layers"""
            
            output = self.feedForward(input)
            outputIndex = len(output) - 1
            actual = output[outputIndex]    

            layers = [[]] + self.layers

            deltas = [ [ 0.0 for node in layer ] for layer in output ]
            
            """
            Calculate output errors for each output perceptron and keep track 
            of error sum. Add error delta values to list.
            """
            for i, outputNode in enumerate(self.outputLayer):
                error = expected[i] - actual[i]
                errorSum += (error ** 2) / 2
                deltas[outputIndex][i] = outputNode.sigmoidActivationDeriv(output[outputIndex - 1]) * error
            """
            Backpropagate through all hidden layers, calculating and storing
            the deltas for each perceptron layer.
            """
            for hiddenLayer in range(outputIndex - 1, 0, -1):
                for i, node in enumerate(layers[hiddenLayer]):
                    weightedSum = 0
                    nextLayer = hiddenLayer + 1
                    for j in range(len(deltas[nextLayer])):
                        weightedSum += layers[nextLayer][j].weights[i + 1] * deltas[nextLayer][j]
                    deltas[hiddenLayer][i] = node.sigmoidActivationDeriv(output[hiddenLayer - 1]) * weightedSum
            
            """
            Having aggregated all deltas, update the weights of the 
            hidden and output layers accordingly.
            """
            for i, layer in enumerate(self.layers):
                for j, node in enumerate(layer):
                    numWeights += node.inSize
                    summedChanges += node.updateWeights(output[i], alpha, deltas[i + 1][j])
            
            #print deltas
            #print "Summed Error:", errorSum, "Summed Weights:", summedChanges
                
        #end for each example
        
        """Calculate final output"""
        averageError = errorSum / (len(examples) * len(self.outputLayer))
        averageWeightChange = summedChanges / numWeights
        return averageError, averageWeightChange
    
def buildNeuralNet(examples, alpha=0.1, weightChangeThreshold = 0.00008,hiddenLayerList = [1], maxItr = sys.maxint, startNNet = None):
    """
    Train a neural net for the given input.
    
    Args: 
        examples (tuple<list<tuple<list,list>>,
                        list<tuple<list,list>>>): A tuple of training and test examples
        alpha (float): the alpha to train with
        weightChangeThreshold (float):           The threshold to stop training at
        maxItr (int):                            Maximum number of iterations to run
        hiddenLayerList (list<int>):             The list of numbers of Perceptrons 
                                                 for the hidden layer(s). 
        startNNet (NeuralNet):                   A NeuralNet to train, or none if a new NeuralNet
                                                 can be trained from random weights.
    Returns
       tuple<NeuralNet,float>
       
       A tuple of the trained Neural Network and the accuracy that it achieved 
       once the weight modification reached the threshold, or the iteration 
       exceeds the maximum iteration.
    """
    examplesTrain,examplesTest = examples       
    numIn = len(examplesTrain[0][0])
    numOut = len(examplesTest[0][1])     
    time = datetime.now().time()
    if startNNet is not None:
        hiddenLayerList = [len(layer) for layer in startNNet.hiddenLayers]
    print "Starting training at time %s with %d inputs, %d outputs, %s hidden layers, size of training set %d, and size of test set %d"\
                                                    %(str(time),numIn,numOut,str(hiddenLayerList),len(examplesTrain),len(examplesTest))
    layerList = [numIn]+hiddenLayerList+[numOut]
    nnet = NeuralNet(layerList)                                                    
    if startNNet is not None:
        nnet =startNNet
    """
    YOUR CODE
    """
    iteration=0
    trainError=0
    weightMod=0
    
    """
    Iterate for as long as it takes to reach weight modification threshold
    """
        #if iteration%10==0:
        #    print '! on iteration %d; training error %f and weight change %f'%(iteration,trainError,weightMod)
        #else :
        #    print '.',
    weightChange = float("inf")
    while iteration < maxItr and weightChange > weightChangeThreshold:
        sumSquareError, weightChange = nnet.backPropLearning(examplesTrain, alpha)
        weightMod += weightChange
        print iteration, maxItr, weightChange
        iteration += 1

    total = 0.0
    correct = 0.0
    for input, expected in examplesTrain:
        output = nnet.feedForward(input)
        actual = output[len(output) - 1]
        total += 1
        if actual == expected:
            correct += 1
    trainError = (total - correct) / total * 100
    time = datetime.now().time()
    print 'Finished after %d iterations at time %s with training error %f and weight change %f'%(iteration,str(time),trainError,weightMod)
                
    """
    Get the accuracy of your Neural Network on the test examples.
    """ 
    
    testError = 0.0
    testGood = 0.0
    total = 0.0  
    testAccuracy=0#num correct/num total
    for input, expected in examplesTest:
        output = nnet.feedForward(input)
        actual = output[len(output) - 1]
        total += 1
        if actual == expected:
            testGood += 1
    testError = total - testGood
    testAccuracy = (testGood) / total
    time = datetime.now().time()
    
    print 'Feed Forward Test correctly classified %d, incorrectly classified %d, test percent error  %f\n'%(testGood,testError,testAccuracy)
    
    """return something"""
    return nnet, testAccuracy


