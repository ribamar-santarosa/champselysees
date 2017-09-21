# example:
# add-commit-files.sh "$(ls)" "$(basename $PWD)"  "file added" # add all files in this project
# add-commit-files.sh "$(ls)" "$(basename $PWD)"  "file changed" "-p" # interactive change all files in this project
[[ ! -z "$1" ]] && files=$1
[[ ! -z "$2" ]] && prefix=$2
[[ ! -z "$3" ]] && message=$3
[[ ! -z "$4" ]] && git_opt=$4
[[ -z "$files" ]] && read   -p "files:"  files
[[ -z "$message" ]] && read   -p "Message for [$files]:"  message && delete_message="True"
for file in $files
  do echo preparing git commit -m \"$prefix: $file:  $message \"...
  #  git add -p $file || git add $file # TODO: not working!!
  git add $git_opt $file
  git commit -m "$prefix $file:  $message "
done

[[ ! -z "$delete_message" ]] && message=
