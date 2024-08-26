#!/bin/bash

# Function to get the last modified date of a file
get_last_modified_date() {
  local file="$1"
  date -r "$file" +"%a %b %d %H:%M:%S %Y %z"
}

# Function to commit a file
commit_file() {
  local file="$1"
  local date_str
  date_str=$(get_last_modified_date "$file")
  git add "$file"
  git commit -m "Committing $file based on last modified time $date_str"
}

# Find all modified files and commit them
find_modified_files() {
  # Find all files and directories
  find . -type f -newermt "$(date --date='1 minute ago' +'%Y-%m-%d %H:%M:%S')" |
  while IFS= read -r file; do
    commit_file "$file"
  done
}

# Find and commit modified files
find_modified_files
