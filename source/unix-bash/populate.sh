#!/bin/bash
# grab current user
user=$(whoami)
# grab current working directory
working_directory=$(pwd)

# run loop
for number in 0 1 2 3 4 5 6 7 8 9
do
  # populate parent directory
  file=new_file_$number
  touch $file
  #test for child folder and populate child directory
  if [ -d child ]; then
    file=child/new_file_$number
    touch $file
  else
    mkdir child
  fi
done

#list parent directory
ls -l
#list child directory
ls -l child
echo "All done"
