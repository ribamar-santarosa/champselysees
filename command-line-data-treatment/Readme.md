# columns_format.rb

gets 2 params: the number of columns (arg1), and a file name (or uri, or file
contents, or will prompt for file contents in standard input) (arg2)

Example:
````
./columns_format.rb  10 "hello you there? what have you been doing?"
hello you
there? what
have you
been doing?

sudo cat /var/log/messages | grep error  -i | ./columns_format.rb 40
14:10:52 localhost gvfsd-network[23917]:
Couldn't create directory monitor on
smb://x-gnome-default-workgroup/. Error:
Operation not supported by backend Feb 5
14:10:55 localhost gvfsd-network[23917]:
Couldn't create directory monitor on
smb://x-gnome-default-workgroup/. Error:
Operation not supported by backend

./columns_format.rb 20 https://raw.githubusercontent.com/ribamar-santarosa/champselysees/master/README.md
# champselysees Il y a
tous ce que vous voulez
aux champs elysees -
collection of tools
````

# unzip_slice_size_2.rb

Alternates  a stream of params into 2 streams (starting from `$5`). 
Understand by examples:

````
./unzip_slice_size_2.rb print "" "" "" ""    "a" "1" "b" "2" ; echo 
ab12

./unzip_slice_size_2.rb pp "" "" "" ""    "a" "1" "b" "2"
"a"
"b"
"1"
"2"

./unzip_slice_size_2.rb puts "" "" "" ""    "a" "1" "b" "2"
a
b
1
2

./unzip_slice_size_2.rb puts "first_elements=[" "]" "second_elements={" "}"    "a" "1" "b" "2" 
first_elements=[a]
first_elements=[b]
second_elements={1}
second_elements={2}
````

# derive_file.rb

instead of replacing a file, duplicate chunks having an entry. 
supposed you have a file modules.txt:
````
#  
#  MY_MODULE_1:
#
#  myModule_1 is a special module.
#  execute it by calling my_module_1 on your interface.
#
#  MY_MODULE_3:
#
#  myModule_3 is a special module.
#  execute it by calling my_module_3 on your interface.
````

probably you want to add entries to my_module_2 too, right? 

 usage:
````
 ./derive_file.rb modules.txt /dev/stdout "" my_module_1 my_module_2 myModule_1 myModule_2 MY_MODULE_1 MY_MODULE_2  # outputs to /dev/stdout
 ./derive_file.rb "" /dev/stdout ""  my_module_1 my_module_2 myModule_1 myModule_2 MY_MODULE_1 MY_MODULE_2  # edit modules.txt instead
````

 probably you want to fine tune the value 
 of regexes variable in the source code. 
 the contain which kind of lines should be grouped
 to the previous chunks (empty lines, comments, ...)


# file_backup.rb

equivalent of option `--parents` in `cp`.

copies a file (or url, if `open-uri` available, or its contents if unexisting
file, or reads from command-line, if still empty) (arg 1), to a destination
(arg 2), appending a hash (or creating one, using the current time, if empty)
(arg 3), and prepending it with a string (or '/' if empty)  (arg 4).


 usage:
````
file=/home/ribamar/tmp/util.pdf
destination=/tmp
append=
prepend=
# note: (arg 4 cannot be given if arg 3 is not given. wrap it with a
comma instead)
./file_backup.rb "${file}" "${destination}" ${append} ${prepend}
````

# Rdoc pages:
https://rawgit.com/ribamar-santarosa/champselysees/master/command-line-data-treatment/doc/index.html
