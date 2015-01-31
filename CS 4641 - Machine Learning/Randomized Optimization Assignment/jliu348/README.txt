I am using a modified version of ABAGAIL for my code, the tests I wrote are included under project2.

Simply compile them alongside ABAGAIL and use the following commands to execute the tests I used for the analysis.

Or just use the JAR file I've included.

Neural Network Tests
	java -cp PATH project2.SpambaseTest ARFF_FILEALG HN ITER
		where: PATH is the path to the compiled java code directory
		       ARFF_FILE is the path to the ARFF dataset file
		       HN is the number of hidden nodes
		       ITER is the number of iterations to train it through
		       ALG is the randomized optimization algorithm to use
			    rhc - Randomized Hill Climbing
			    sa - Simulated Annealing
				requires two more parameters in this order: ST CF
					where ST is the starting temperature
					      CF is the cooling factor
			    ga - Genetic Algorithm
				requires three more parameters in this order S MA MU
					where S is the starting population
					      MA is the number of individuals to mate per iteration
					      MU is the number of mutations to induce per iteration
	It will run the specified algorithm. Printing the sum of squared error and training accuracy every iteration.
	It concludes with final accuracy and the total time it took to run that many iterations.

Other Tests
	Four Peaks
		java -cp PATH project2.FourPeaksTest N T ITER
			where N is the input size
			      T is the "trigger' point of the function
			      ITER is the number of times the test is to be done with each algorithm
	Flip Flop
		java -cp PATH project2.FourPeaksTest N ITER
			where N is the input size
			      ITER is the number of times the test is to be done with each algorithm
	Traveling Salesman
		java -cp PATH project2.FourPeaksTest N ITER
			where N is the number of cities to use for the problem
			      ITER is the number of times the test is to be done with each algorithm
	
	All three will run ITER number of tests on each algorithm using predetermined parameters (listed in the analysis).
	It will print the final result of each test, along with the total amount of time it took to run the test in seconds.
	