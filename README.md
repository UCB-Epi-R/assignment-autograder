# Student-Facing Autograder in R 

When autograding is implemented in assignments, students are able to receive automated feedback on their work. The autograder works in-line with any R or RMD file, displaying student progress in the RStudio console.

Autograder tests range in scope and can be customized based on the needs of a course. Instructors may choose to include sanity checks (ex. testing for data types or range of values) or completely comprehensive equality checks. Instructors may also differentiate between public and private test cases to create an additional layer of grading that is blinded to the student.

There are three main parts in an assignment’s autograder workflow:
- `autograder_setup.R` is the base autograder script that contains pre-written functions. You will not have to make any edits to this file
- `ok.R` files are created for every assignment. This is where you will write tests for homework assignments
  - `ok.R` files load `autograder_setup.R`
- Assignment files are R or RMD files that students complete. This is where you will implement the autograder by calling functions defined in `autograder_setup.R` and the corresponding ok.R file.
  - Assignment files load `ok.R` files

## Set-Up: Overall Structure
`autograder_setup.R` contains all the functionality needed for basic autograding, including two types of checks and problem/assignment progress reports (see Appendix A for documentation). To set-up the autograder for your course, download `autograder_setup.R` and save it to the same repository that contains your course materials.

We recommend that you follow the following file structure for your course materials, storing all autograder materials in a setup folder:

- **PHW250FG**
  - phw250fg-dev.RProj (project file used to set correct working directories)
  - data (contains all data that is used throughout the course)
  - setup
    - autograder-setup (contains autograder files for all assignments)
      - autograder-setup.R (base autograder script)
      - hw0-autograder (contains autograder files for homework 0)
            - hw0-autograder.R (autograder script for homework 0)
            - ...
      - hw1-autograder (contains autograder files for homework 1)
            - hw1-autograder.R (autograder script for homework 1)
      - ...
  - homework (contains blank student copies for assignments)
    - hw0 (contains blank student copy of homework 0)
    - hw1 (contains blank student copy of homework 1)
    -  …
  - solutions (contains copies for assignments with solutions)
    - hw0-solutions (contains solutions for homework 0)
    - hw1-solutions(contains solutions for homework 1)
    -  …

## Set-Up: Individual Assignments
Each autograder-enabled homework assignment will consist of two scripts: a ok.R file containing tests and a R/RMD assignment file that students fill out.

### ok.R files

To implement autograder tests for an individual assignment `ASSIGNMENT_TITLE.R`, create a new R script called `ASSIGNMENT_TITLE.ok.R` in a new folder called `ASSIGNMENT_TITLE` within the `autograder_setup` folder (see structure above.).

At the top of the script, copy the following code:
```
source("setup/autograder_setup/autograder_setup.R")
AutograderInit = function() {
  AutograderSetUp(n) # Replace n with the # of questions in the assignment
}
```

Define a function called `CheckProblemX()` for each Problem #X that you want to run autograding tests on. This function takes no arguments, and is run by students after completing its corresponding problem. At the start of each function, copy the following code:
```
problemNumber <<- X # Replace X with the question number
scores[problemNumber] <<- 0
num_tests <<- n # Replace n with the total number of tests in the question
tests_failed <<- num_tests
```
 
At this point, you can start defining tests that compare student answers to the expected solutions. There are two types of tests that you can use:
- `TestCase()` uses `assert_that` statements to check student work. The autograder will stop running after the first error it encounters and display student progress. This type of test is best fit for questions where there is a logical order to checks (ex. check that student answer is a number -> check that student answer falls in a certain range -> check that a student answer is equal to the right value)
- `CheckPoint()` uses `tryCatch` statements to check student work. The autograder will run through all checks, regardless of how a student answered the question. Different feedback statements are provided to students at all checkpoints depending on if they passed or failed the test. This type of test is best fit for questions where there is not a logical order to checks (ex. check that student has defined a ggplot -> check that the ggplot is a barplot -> check that y-axis label is correct -> check that bar fill color is correct)
To define a test, call either the `TestCase(...)` or `Checkpoint(...)` function using the appropriate arguments for your question. Both functions require that the test argument evaluates to a boolean (`TRUE`/`FALS`E value).

For an example of an `ok.R` file, see `setup/autograder_setup/example_tests.ok.R` in this repo, the autograder script for `assignments/example/example_student_assignment.R`. For additional documentation on `TestCase` and `Checkpoint`, see Appendix A.
 
### Assignment Files

To link an assignment to its ok.R file, copy the following code to the top of the assignment script:
```
# Load okR autograder
tryCatch({source('setup/autograder_setup/ ASSIGNMENT_TITLE/ ASSIGNMENT_TITLE.ok.r)},
     	warning = function(e){print("Error: did you remember to load the COURSE_NAME.Rproj file?")})
AutograderInit()
```

After each question function, call its corresponding autograder function. Each question should follow a structure to the one below:
```
Q1 = "<<<<< YOUR CODE HERE >>>>>"
Q1
CheckProblem1()
```

At the end of the assignment, copy the following code to allow students to check their overall progress:
```
MyTotalScore()
```

For an example of a student assignment with autograder integration, see `assignments/example/example_student_assignment.R` in this repo.

## Publishing Assignments with Autograders
To distribute assignments and their respective autograder files, we recommend that you use interact links that automatically pull assignments into student JupyterHub environments. You can find documentation on JupyterHub/DataHub setup here.

**Only provide students with public okR tests.** The `ok.R` files of each assignment will be copied for students, where they could find what is being tested. Be cautious of including solution code In your ok.R files to prevent student cheating.

To obfuscate code, we recommend that you generate correct objects (ggplots, data frames, etc.) and save it as an RDS file within your `setup/autograder_setup/ASSIGNMENT_TITLE folder`. When you need to reference these objects for TestCases or Checkpoints, load the RDS files to a new variable and use that variable to write your tests.


# Appendix A: `autograder_setup.R` Documentation
`autograder_setup.R` includes base functions that provide instant grading feedback to students working on R coding assignments.

**Package dependencies**: here, jsonlite, rlist, checkr, assertthat, dplyr

**Functions:**

- `AutograderSetUp`: Initializes vector to track scores for each problem
  - Inputs:
    - `num_questions`: number of questions in the assignment (integer)

- `TestCase`: Checks student work using assert_that test cases. Autograder will stop running after the first failed test case and show the student's progress for the question. Used for questions where there is a logical order to test cases.
  - Inputs:
    - `test`: conditional statement that checks student work. Evaluates to TRUE if correct, FALSE if incorrect (boolean)
    - `error_message`: Message to display if a student fails the test case.

- `CheckPoint`: Checks student work using print statements. Autograder will run through all checkpoints, regardless of how students answered the question. Feedback statements will be provided to students depending if they passed/failed the test case. Used for questions where there is no logical order to test cases, or if test cases are unrelated
  - Inputs:
    - `checkpoint_number`: the number of the checkpoint within the questions(integer)
    - `test`: conditional statement that checks student work. Evaluates to TRUE if correct, FALSE if incorrect (boolean)  
    - `correct_message`: Message to display if a student passes the test case. (string)
    - `error_message`: Message to display if a student fails the test case. (string)

- `ReturnScore`:  Returns a student's progress on a particular question. Displays the number of test cases passed, the number of test cases failed, the percent of test cases passed, and the overall question score.
  - Inputs:
    - `problemNumber`: the number of the current question (integer)
    - `num_tests`: the total number of test cases related to the question (integer)
    - `problemNumber`: the total number of test cases failed in the question (integer)

- `MyTotalScore`: Renders scores from each problem and returns as a dataframe. Runs at the end of each assignment script to display overall student progress.

