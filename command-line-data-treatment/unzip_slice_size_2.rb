#!/usr/bin/ruby

#  usage:
# ./unzip_slice_size_2.rb print "" "" "" ""    "a" "1" "b" "2" ; echo 
# ab12
# ./unzip_slice_size_2.rb pp "" "" "" ""    "a" "1" "b" "2" ; echo 
# "a"
# "b"
# "1"
# "2"
# ./unzip_slice_size_2.rb puts "" "" "" ""    "a" "1" "b" "2" ; echo 
# a
# b
# 1
# 2
#
# ./unzip_slice_size_2.rb puts "first_elements=[" "]" "second_elements={" "}"    "a" "1" "b" "2" 
# first_elements=[a]
# first_elements=[b]
# second_elements={1}
# second_elements={2}
# ````


require 'pp'

class ProjectExecution 
    def non_neutral_element args=ARGV
      # returns something that can be tested as false if the first element
      # in array is considered to be the neutral element of the class.
      # otherwise, returns that element
      element = args.shift
      result = (element && element.size) == 0 ? nil : element
      result
    end


  def unzip_slice_size_2 args=ARGV
    print_method = (non_neutral_element [args.shift]) || "print"
    prepend_0 = args.shift
    append_0 = args.shift
    prepend_1 = args.shift
    append_1 = args.shift
    args.each_slice(2).map{|e| [ "#{prepend_0}#{e[0]}#{append_0}", "#{prepend_1}#{e[1]}#{append_1}" ] }.transpose.map(&:compact).flatten.each(&method(print_method))
  end
end

ProjectExecution.new.unzip_slice_size_2  

