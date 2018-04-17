#!/usr/bin/env ruby

# Collection of Ruby functions
# * output
# normally outputs to STDERR, with
# no mercy
# STDOUT, just qualified output:
# only if the function is expected
# to output something
class Rubyment


  def initialize memory = {}
    @memory = {
      :invoke => [],
      :stderr => STDERR,
      :time   => Time.now,
    }
    @memory.update memory
    invoke = @memory[:invoke].to_a
    self.method(invoke[0]).call *(invoke[1, -1])
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


  # save url contents to a local file location
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


  # returns the contents of file (or empty, or a default
  # if a second parameter is given).
  # if file is a nonexisting filepath, or by any reason
  # throws any exception, it will be treated as contents
  # instead
  # file can be a url, if 'open-uri' is available.
  def filepath_or_contents file, contents = ""
    stderr = @memory[:stderr]
    (require 'open-uri') && open_uri = true
    require 'fileutils'
    file = file.to_s
    file_is_filename = true
    open_uri && (
      contents = open(file).read rescue  (file_is_filename = false) || file
    ) || (
      contents = File.read file rescue  (file_is_filename = false) || file
    )
    contents
  end

  # returns the first value of args if it is a non empty
  # string, or prompt.
  # useful for reading file contents, e.g.
  def input_non_empty_string_or_multiline_prompt args=ARGV
    stderr = @memory[:stderr]
    stderr.print "multiline[control-D to stop]:"
    args.shift.to_s.split("\0").first ||  readlines.join
  end


  def input_non_empty_filepath_or_contents_or_multiline_prompt args=ARGV
    stderr = @memory[:stderr]
    stderr.print "multiline[control-D to stop]:"
    (filepath_or_contents args.shift).to_s.split("\0").first ||  readlines.join
  end

  def input_shift_or_empty_string args=ARGV, default = ''
    args.shift || default
  end

  def input_shift args=ARGV
    args.shift
  end


  # place a \n at every max_column chars
  # approximately (a word can be bigger
  # than max_column, and some other
  # situations)
  def string_in_columns s, max_column=80
    max_column = max_column.to_i
    as = 0 ; ln = 0 ; t =  s.split.chunk {|l| ((l.size + as) <= max_column ) && (as += l.size ) && ln || (as = l.size; ln += 1)  }.entries.map {|a| a.last.join(" ") }.join("\n")
  t
  end


  def shell_string_in_columns args=ARGV
    stderr = @memory[:stderr]
    time   = @memory[:time]
    number_of_columns = input_shift args
    text = input_non_empty_filepath_or_contents_or_multiline_prompt args
    puts (string_in_columns text, number_of_columns)
  end


  # print arguments given
  def test__ args=ARGV
    stderr = @memory[:stderr]
    time   = @memory[:time]
    puts args.join " "
  end


  # makes a rest request. todo: parameters
  def rest_request args=ARGV
    require 'base64'
    require 'rest-client'
    require 'json'
    stderr = @memory[:stderr]
    time   = @memory[:time]

    atlasian_account="my_atlasian_account"
    jira_host = "https://mydomain.atlassian.net/"
    issue = "JIRAISSUE-6517"
    url = "#{jira_host}/rest/api/2/issue/#{issue}/comment"
    # ways to set base64_auth:
    # 1) programmatically: let pw in plain text:
    # auth = "my_user:my_pw"
    # base64_auth = Base64.encode64 auth
    # 2) a bit safer (this hash can be still used
    # to hijack your account):
    #  echo "my_user:my_pw" | base64 # let a whitespace in the beginning
    base64_auth = "bXlfdXNlcjpteV9wdwo="
    # todo: it has to be interactive, or fetch from a keying
    # to achieve good security standards
    method = :get
    method = :post
    timeout = 2000
    headers = {"Authorization" => "Basic #{base64_auth}" }
    verify_ssl = true
    json =<<-ENDHEREDOC
    {
        "body" : "my comment"
    }
    ENDHEREDOC
    payload = "#{json}"
    request_execution = RestClient::Request.execute(:method => method, :url => url, :payload => payload, :headers => headers, :verify_ssl => verify_ssl, :timeout => timeout)
    parsed_json = JSON.parse request_execution.to_s
    stderr.puts parsed_json
    parsed_json
  end

end

Rubyment.new({:invoke => ARGV})

