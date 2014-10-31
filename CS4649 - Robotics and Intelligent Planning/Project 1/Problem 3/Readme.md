Either compile and run from source or run the jar file Planner.jar with
the problem file as an argument.

To run jar file run command:
  java -jar Planner.jar 2.txt

Problem files for the four problems are provided as:
  2.1.txt, 2.2.txt, 2.3.txt and 2.challenge.txt

Encoding:

width height num-of-boxes
robot-x robot-y name-sensitive
box1-name box1-x box1-y
box2-name box2-x box2-y
...
box1-name box1-goal-x box1-goal-y
box2-name box2-goal-x box2-goal-y
grid-of-walls


 - name-sensitive is 1 if the boxes have names and 0 otherwise.

 - box-name can be anything other than empty string if the boxes don't have names

 - grid-of-walls is a grid of zeros and ones where the walls are zeros. 

 - The four problems in the hw have already been encoded.
