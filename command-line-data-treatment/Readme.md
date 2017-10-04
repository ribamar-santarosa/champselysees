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
