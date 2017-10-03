# git-tools
usage:
````
./add-commit-files.sh "$files" "$prefix"  "$message" "$git_opt" 
````
````
./add-commit-files.sh "$(ls)" "$(basename $PWD):"  "file added" # add all files in this project/this dir
./add-commit-files.sh "$(ls)" "$(basename $PWD):"  "file changed" "-p" # interactive change all files in this project
./add-commit-files.sh "$(git status | grep modified: | cut -f 2 -d :  | xargs )"  "$(basename $PWD):"  "file changed" "-p" # interactive change all files in this project, same as above, but changed files only
./add-commit-files.sh "$(ls)" "$(basename $PWD):"  "file changed" "-p" "echo" # echo git commands instead

````
