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


# Rdoc pages:
https://rawgit.com/ribamar-santarosa/champselysees/master/command-line-data-treatment/doc/index.html
