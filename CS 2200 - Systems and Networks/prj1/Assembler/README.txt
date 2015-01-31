This is the assembler which is used to convert your raw assembly files (<example>.s) to raw byte code that can then be loaded into your implemented Project 1.

Please DO NOT use the gt16 assembler as it has known issues and all support for it has been dropped.

To use this new assembler, you must have perl installed on your system. To install Debian/Ubuntu, please run the following command in the console:
		
	sudo apt-get install perl

To assemble on of your programs, say example.s, run the following command in the console:
	
	perl lcas.pl example.s

This will output two files, example.lc and example.sym. The raw hex code that should be loaded into your data path is contained in example.lc.