#########################################################################
# Autograding Assignments in R

# This script includes base functions that provide instant grading feedback 
# to students working on R coding assignments. 

# Developed by Anna Nguyen, Nolan Pokpongkiat, and Kunal Mishra for 
# Epidemiologic Methods II (PHW250F, PHW250G)
#########################################################################

# Load dependencies
library(here)
library(jsonlite)
library(rlist)
library(dplyr)
library(assertthat)

#--------------------------------------------------------------------------------------
# AutograderSetUp

# Description: Initializes vector to track scores for each problem

# Inputs:
#   - num_questions: number of questions in the assignment (integer)
#--------------------------------------------------------------------------------------

AutograderSetUp = function(num_questions) {
  scores <<- vector(mode="character", length=num_questions)  
  for (problemNumber in 1:num_questions){
    scores[problemNumber] <<- 0
  }
}

#--------------------------------------------------------------------------------------
# TestCase

# Description: Checks student work using assert_that test cases.
#   Autograder will stop running after the first failed test case 
#   and show the student's progress for the question. 
#   Used for questions where there is a logical order to test cases.

# Inputs:
#   - test: conditional statement that checks student work. Evaluates to 
#           TRUE if correct, FALSE if incorrect (boolean)
#   - error_message: Message to display if a student fails the test case.
#--------------------------------------------------------------------------------------

TestCase = function(test, error_message = "Test Failed"){
  if (test) {
    tests_failed <<- tests_failed - 1
  } else {
    ReturnScore(problemNumber, num_tests, tests_failed)
    assert_that(test, msg =  error_message)
  }
}

#--------------------------------------------------------------------------------------
# CheckPoint

# Description: Checks student work using tryCatch.
#   Autograder will run through all checkpoints, regardless of how students
#   answered the question. Feedback statements will be provided to students 
#   depending if they passed/failed the test case.
#   Used for questions where there is no logical order to test cases, or if
#   test cases are unrelated

# Inputs:
#   - checkpoint_number: the number of the checkpoint within the questions(integer)
#   - test: conditional statement that checks student work. Evaluates to 
#           TRUE if correct, FALSE if incorrect (boolean)
#   - correct_message: Message to display if a student passes the test case. (string)
#   - error_message: Message to display if a student fails the test case. (string)
#--------------------------------------------------------------------------------------

CheckPoint = function(checkpoint_number, test, correct_message = "", error_message = ""){
  correct = sprintf("Checkpoint %d Passed", checkpoint_number)
  if (nchar(correct_message) != 0){
    correct = paste0(correct, ": ", correct_message)
  }
  
  error = sprintf("Checkpoint %d Error", checkpoint_number)
  if (nchar(error_message) != 0){
    error = paste0(error, ": ", error_message)
  }
  
  tryCatch({
    if (test) {
      tests_failed <<- tests_failed - 1
      print(correct)
    } else {
      print(error)
    }
  }, error = function(e) {
    print(error)
  }, warning = function(e) {
    print(error)
  }
  )
  
  
}

#--------------------------------------------------------------------------------------
# ReturnScore

# Description: Returns a student's progress on a particular question. Displays the 
#   number of test cases passed, the number of test cases failed, the percent of 
#   test cases passed, and the overall question score.

# Inputs:
#   - problemNumber: the number of the current question (integer)
#   - num_tests: the total number of test cases related to the question (integer)
#   - num_failed: the total number of test cases failed in the question (integer)
#--------------------------------------------------------------------------------------

ReturnScore = function(problemNumber, num_tests, num_failed) {
  num_passed = num_tests - num_failed
  score = ifelse(num_failed == 0, 1, 0)
  
  cat(sprintf("\nProblem %d\nCheckpoints Passed: %d\nCheckpoints Errored: %d\n%g%% passed | Score: %d/1\n", 
              problemNumber, num_passed, num_failed, round(num_passed/num_tests * 100, digits = 2), score))
}

#--------------------------------------------------------------------------------------
# MyTotalScore

# Description: Renders scores from each problem and returns as a dataframe.
#   Runs at the end of each assignment script to display overall student progress.
#--------------------------------------------------------------------------------------

MyTotalScore = function() {
  scoresList = c()
  problemNumber = 1
  problemTitles = c()
  totalCorrect = 0
  
  while (problemNumber <= length(scores)) {
    
    score = as.numeric(scores[problemNumber])
    if (score == 1) {
      scoresList = c(scoresList, "1/1")
      totalCorrect = totalCorrect + 1
    } else {
      scoresList = c(scoresList, "0/1")
    }
    
    problemTitle = sprintf("Problem %d:", problemNumber)
    problemTitles = c(problemTitles, problemTitle)
    
    problemNumber = problemNumber + 1
  }
  
  problemTitles = c(problemTitles, "Total Score:")
  scoresList = c(scoresList, sprintf("%d/%d", totalCorrect, length(scores)))
  
  renderedScores = data.frame(
    Score = scoresList
  )
  rownames(renderedScores) = problemTitles
  colnames(renderedScores) = ""
  
  return(renderedScores)
}
