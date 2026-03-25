#!/bin/env bash 


#   Command Breakdown
#       IFS=$'\n':
#
#   This sets the Internal Field Separator (IFS) to a newline character. This means that when the command reads input, it will treat each line as a separate item.
#
#
#
#       read -r -d '' -a commit_array <<< "$(git log --pretty=format:"%H" --all)":
#
#   This part captures the output of the command inside the $(...) into an array called commit_array.
#
#
#
#       git log --pretty=format:"%H" --all: This retrieves all commit hashes (%H) from all branches in the repository.
#
#           -r: Prevents backslashes from being interpreted as escape characters.
#
#           -d '': This tells read to keep reading until it encounters an empty string, allowing it to read all lines.
#
#           -a commit_array: This specifies that the input will be stored in an array named commit_array.
#
#
#       git grep -n "\bhey\b" "${commit_array[@]}":
#
#           This uses git grep to search for the string "hey" in the specified commits.
#           \bhey\b: The \b word boundaries ensure that only the whole word "hey" is 
#           matched (not as part of another word).
#
#       "${commit_array[@]}": This expands the array of commit hashes as individual arguments to git grep.
#
#
#   Summary
#   Overall, this bash command accomplishes the following:
#
#   It retrieves all commit hashes from the Git repository and stores them in an array.
#
#   Then, it searches through the content of those commits for the word "hey," displaying 
#   line numbers (-n) where it finds matches.
#
#   This method allows you to effectively search through the entire history of a Git 
#   repository for specific content while ensuring that you only match whole words.
#
#


IFS=$'\n' read -r -d '' -a commit_array <<< \
    "$(git log --pretty=format:"%H" --all)"; \
    git grep -ni "$1" "${commit_array[@]}"
#git grep -n "\b$1\b" "${commit_array[@]}"