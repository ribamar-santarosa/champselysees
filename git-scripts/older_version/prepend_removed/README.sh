# git-tools
usage:
````
./add-commit-files.sh "$files" "$prefix"  "$message" "$git_opt" 
````
````
./add-commit-files.sh "$(ls)" "$(basename $PWD):"  "file added" # add all files in this project/this dir
./add-commit-files.sh "$(ls)" "$(basename $PWD):"  "file changed" "-p" # interactive change all files in this project
````
