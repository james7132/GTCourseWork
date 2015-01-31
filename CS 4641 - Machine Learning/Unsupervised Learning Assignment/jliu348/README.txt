For everything except ICA, I used Weka. Other than the mentioned altered parameters mentioned in the analysis. I used the standard settings.

For Random Projection, I used the seeds 42, 82, and 100 as the seeds for the three trials in each test.

For ICA, I used FastICA for Matlab and the library found at http://www.mathworks.com/matlabcentral/fileexchange/21204-matlab-weka-interface to 
import my arff files into MATLAB 
	The file is imported using loadARFF, then converted to a matrix using weka2matlab.
	The resultant matrix needs to be transposed to be used properly.
	I used fasticag for the actual algorithm itself.
