#################################################
# Autograding Assignments in R

# Example Student Assignment
#################################################

# Load okR autograder - you'll see these two lines of code at the 
# top of each assignment. It sets up the checkpoints for you to use
# throughout the rest of the assignment.

tryCatch({source('setup/autograder_setup/example/example_tests.ok.R')},
         warning = function(e){print("Error: did you remember to load the r-autograder.Rproj file?")})
AutograderInit()

#-----------------------------------------------
# Problem 1: Set x to a mathematical equation that 
# evaluates to the number 5. 
# Replace "<<<<<<<<<<<<< YOUR CODE HERE >>>>>>>>>>>>>>>"
# with your answer. Run your newly written code.

# To run your code, click on the line you want to run 
# and press ctrl + enter on your keyboard
#-----------------------------------------------
x = "<<<<<<<<<<<<< YOUR CODE HERE >>>>>>>>>>>>>>>"

# Now try running the autograder!
CheckProblem1()

# Let's see what happens when you pass a wrong answer
# through the autograder. Try running all the cells below
# in order.

x = "5" 
CheckProblem1()


x = 2 + 2
CheckProblem1()

#-----------------------------------------------
# Problem 2: Set y to a mathematical equation that 
# evaluates to the number 7. 
# Replace "<<<<<<<<<<<<< YOUR CODE HERE >>>>>>>>>>>>>>>"
# with your answer. Run your newly written code.

# To run your code, click on the line you want to run 
# and press ctrl + enter on your keyboard
#-----------------------------------------------
y = "<<<<<<<<<<<<< YOUR CODE HERE >>>>>>>>>>>>>>>"

# Now try running the autograder!
CheckProblem2()

# Let's see what happens when you pass a wrong answer
# through the autograder. Try running all the cells below
# in order.

y = "7" 
CheckProblem2()


y = 2 + 6
CheckProblem2()

# Congratulations! You just finished your first R assignment. 
# Run the code below to view your overall score
MyTotalScore()
