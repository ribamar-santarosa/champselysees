#!/usr/bin/ruby

#  instead of replacing a file, duplicate chunks having an entry. 
#  supposed you have a file modules.txt:
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
#
#
#   probably you want to add entries to my_module_2 too, right? 
#
#  usage:
#  ./derive_file.rb modules.txt /dev/stdout "" my_module_1 my_module_2 myModule_1 myModule_2 MY_MODULE_1 MY_MODULE_2  # outputs to /dev/stdout
#  ./derive_file.rb "" /dev/stdout ""  my_module_1 my_module_2 myModule_1 myModule_2 MY_MODULE_1 MY_MODULE_2  # edit modules.txt instead
#
#  probably you want to fine tune the value 
#  of regexes variable in the source code. 
#  the contain which kind of lines should be grouped
#  to the previous chunks (empty lines, comments, ...)
class ProjectExecution 

  def non_neutral_element args=ARGV
    # returns something that can be tested as false if the first element
    # in array is considered to be the neutral element of the class.
    # otherwise, returns that element
    element = args.shift
    result = (element && element.size) == 0 ? nil : element
    result
  end

  def replace! s, replacements ; replacements.each{|r| what, with = r ;  (s.gsub! what, with) } ; s ; end

  def derive_file args=ARGV
    infile  = args.shift
    outfile = (non_neutral_element [args.shift])  || infile
    regexes = (non_neutral_element [args.shift])  || [/^$/, (Regexp.new '^#$') ]
    replacements = Hash[*args].to_a
    lines =  File.readlines infile
    last_chunck = false
    line_chunks = lines.chunk {|l| last_chunck = (( last_chunck && regexes.map {|regex| (l.index regex)}.any? || replacements.transpose[0].map {|what| (l.index what) }.any? ) && true || false) }.entries

    new_contents = line_chunks.map{ |line_chunck|  derive, _lines = line_chunck ;  derive && ( _lines.concat ( _lines.map{ |_l| (replace! _l.clone, replacements)  }) ) || _lines }


    File.write outfile, new_contents.join

  end
end

#    replacements = [ ["zookeeper", "jupyterhub"], ["ZooKeeper", "JupyterHub"], ["ZOOKEEPER", "JUPYTERHUB"],  ["Zookeeper", "Jupyterhub"]  ]

ProjectExecution.new.derive_file

