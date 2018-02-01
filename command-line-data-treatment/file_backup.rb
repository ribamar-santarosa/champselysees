#!/usr/bin/env ruby

class ProjectExecution


  def initialize memory = {}
    @memory = {
      :stderr => STDERR,
      :time   => Time.now,
    }
    @memory.update memory
  end


  # if file is a nonexisting filepath, or by any reason
  # throws any exception, it will be treated as contents
  # instead, and the filename will treated as ""
  # file can be a url, if 'open-uri' is available.
  def file_backup file = __FILE__ , dir = '/tmp/', append = ('-' + Time.now.hash.abs.to_s), prepend='/'
    stderr = @memory[:stderr]
    (require 'open-uri') && open_uri = true
    require 'fileutils'
    file_is_filename = true
    open_uri && (
      contents = open(file).read rescue  (file_is_filename = false) || file
    ) || (
      contents = File.read file rescue  (file_is_filename = false) || file
    )
    stderr.puts "location = dir:#{dir} + prepend:#{prepend} + (#{file_is_filename} && #{file} || '' ) + #{append}"
    location = dir + prepend + (file_is_filename && file || '' ) + append
    stderr.puts "FileUtils.mkdir_p File.dirname #{location}" # note "~" doesn't work
    FileUtils.mkdir_p File.dirname location # note "~" doesn't work
    File.write location, contents
    contents
  end


  def save_file url, location, wtime=0
  require 'open-uri'
   require 'fileutils'
   FileUtils.mkdir_p File.dirname location # note "~" doesn't work
    contents = open(url).read
    r = File.write location, contents
    sleep wtime
    contents
  end


  def url_to_str url, rescue_value=nil
  require 'open-uri'
    contents = open(url).read rescue rescue_value
  end


  # returns the first value of args if it is a non empty
  # string, or prompt.
  # useful for reading file contents, e.g.
  def input_non_empty_string_or_multiline_prompt args=ARGV
    stderr = @memory[:stderr]
    stderr.print "multiline[control-D to stop]:"
    args.shift.to_s.split("\0").first ||  readlines.join
  end


  def input_shift_or_empty_string args=ARGV, default = ''
    args.shift || default
  end

  def input_shift args=ARGV
    args.shift
  end

  def main args=ARGV
    stderr = @memory[:stderr]
    time   = @memory[:time]
    file    = input_non_empty_string_or_multiline_prompt args
    dir     = input_shift_or_empty_string args
    append  = input_shift_or_empty_string args, '.' + time.strftime("%Y.%m.%d_%H:%M:%S") + "." + time.hash.abs.to_s
    stderr.puts "append{#{append}}append"
    prepend = input_shift_or_empty_string args, '/'
    file_backup file, dir, append, prepend
  end
end

ProjectExecution.new.main

