#!/usr/bin/env ruby

# Collection of Ruby functions
# * output
# normally outputs to STDERR, with
# no mercy
# STDOUT, just qualified output:
# only if the function is expected
# to output something
class Rubyment

  # this class very often needs to split
  # first argument and remaining elements.
  # args:
  # args
  # default:
  # ARGV
  # returns:
  # [ args[0], args[1..-1] ]
  def array_first_remainder args=ARGV
    [ args[0], args[1..-1] ]
  end


  # invoke first arg with following args
  # used by initialize
  def invoke args=ARGV
    stderr = @memory[:stderr]
    method_name, arg_list = array_first_remainder args
    !method_name && (return true)
    begin
      # this condition could become ambiguous only when
      # a function has only one argument (if it has
      # more, the rescue case would fail anyway. if
      # it has zero, both are equally OK).
      # In only one argument case, it is better not to
      # splat -- because most of the functions takes
      # an array as argument. the drawback is that
      # functions taking only one argument can't be
      # called from the command line (an array will
      # be given to them)
      self.method(method_name).call (arg_list)
    rescue ArgumentError => e
      begin
        self.method(method_name).call *(arg_list)
      rescue ArgumentError => e2
        # it didn't work -- the arguments given can't
        # be fit. better just try to let the caller
        # figure out when it first called the function.
        stderr.puts e2
        raise e
      end
    end
  end

  def initialize memory = {}
    @memory = {
      :invoke => [],
      :stderr => STDERR,
      :stdout => STDOUT,
      :stdin  => STDIN,
      :time   => Time.now,
      :major_version => "0.1",
      :basic_version => (Time.now.to_i  / 60), # new one every minute
      :filepath => __FILE__,
      :running_dir => Dir.pwd,
      :home_dir => Dir.home,
      :system_user => ENV['USER'] || ENV['USERNAME'],
      :system_user_is_super => ENV['USER']  == "root", # changed plan: platform indenpend.
      :static_separator_key => "strings_having_this_string_not_guaranteed_to_work",
      :static_end_key => "strings_havinng_this_string_also_not_guaranteed_to_work",
    }
    @memory.update memory.to_h
    invoke @memory[:invoke].to_a
  end


  # returns a version number comprised
  # of a major and a minor number
  # args:
  # [major_version (String or nil), minor_version (String or nil) ]
  # defaults:
  #  [@memory[:major_version]], @memory[:basic_version]]
  # returns:
  # "#{major}.#{minor}"
  def version args=ARGV
    memory = @memory
    major_version = memory[:major_version]
    basic_version = memory[:basic_version]
    major, minor = args
    major ||= major_version
    minor ||= basic_version
    "#{major}.#{minor}"
  end


  # enables the possibility to inkove a second method with
  # the results of a first one. eg, the results of a method
  #  called file_permissions_octal which returns without output
  # can be output as:
  # [ "puts", "file_permissions_octal", "/"]
  # TODO; flawed example
  def invoke_double args=ARGV
    second_invokation, first_invokation = [args[0], args[1..-1]]
    first_invokation_result = (invoke first_invokation)
    invoke [second_invokation] + [first_invokation_result].flatten(1)
  end


  # returns a Class object out of class_name (or itself if it is already
  # a class)
  def containerize args=ARGV
    [args].flatten 1
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


  # returns a Class object out of class_name (or itself if it is already
  # a class)
  def to_class args=ARGV
    class_name, future_arg = containerize args
    begin
      class_object = ( class_name.is_a? Class ) && class_name || (Object.const_get class_name.to_s)
    rescue NameError => nameErrorE
      nil
    end
  end


  # returns a Method (object.method if object is
  # given). give self as object to look up
  # at the current context
  # args:
  # [ name (String), object (Object) ]
  # returns:
  #  method_object (Method)
  def to_method args=ARGV
    stderr = @memory[:stderr]
    name, object = containerize args
    begin
      method =  object.method("method").call(name)
    rescue NameError => nameError
      # every object (even nil) has :method,
      # and every Method has :call: exception
      # is thrown in call
      stderr.puts nameError
      nil
    end
  end

  # calls object.method call_args
  # note: function closed for extension.
  # a new extension if ever made, will 
  # be created with a new function.
  # args:
  # [method (Method or String), object (Object), call_args (Array)]
  # returns:
  #
  def object_method_args_call args=ARGV
    stderr = @memory[:stderr]
    method, object, *call_args = containerize args
    object ||= self
    method = to_method [method, object]
    call_args = call_args && (containerize call_args)
    begin
      call_args && (method.call *call_args) || method.call
    rescue NameError => nameError
      # every object (even nil) has :method,
      # and every Method has :call: exception
      # is thrown in call
      stderr.puts nameError
      nil
    end
  end


  # args:
  # path (String)
  # returns:
  # file_permissions_octal (Integer, ready to go to chmod, or nil,
  # if file doesn't exist)
  def file_permissions_octal path
    File.stat(path).mode.to_s(8).split("")[-4..-1].join.to_i(8) rescue nil
  end


  # save url contents to a local file location
  # url can be a uri to a local file
  # args:
  # url (String), location (String), wtime (Integer)
  # more (Hash)
  # details:
  # more[:username], more[:password] for http_basic_authentication
  # returns
  #  contents of url (String)
  def save_file url, location, wtime=0, more = {}
    require 'open-uri'
    require 'fileutils'
    FileUtils.mkdir_p File.dirname location # note "~" doesn't work
    user = more[:username]
    pw = more[:password]
    contents = open(url, :http_basic_authentication => [user, pw]).read
    r = File.write location, contents
    sleep wtime
    contents
  end


  # returns url contents
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
  # string, or prompt for a multi line string.
  # useful for reading file contents, e.g.
  def input_non_empty_string_or_multiline_prompt args=ARGV
    stderr = @memory[:stderr]
    stderr.print "multiline[control-D to stop]:"
    args.shift.to_s.split("\0").first ||  readlines.join
  end


  # returns the filepath_or_contents of the first value of args
  # if it is a non empty string,
  # or prompt for a multi line string.
  # useful for reading file contents, e.g.
  def input_non_empty_filepath_or_contents_or_multiline_prompt args=ARGV
    stderr = @memory[:stderr]
    stderr.print "multiline[control-D to stop]:"
    (filepath_or_contents args.shift).to_s.split("\0").first ||  readlines.join
  end


  # opens an echoing prompt, if arg1 is nil or empty
  # args:
  # [ arg1 (String or nil)]
  def input_single_line args=ARGV
    stderr = @memory[:stderr]
    stdin  = @memory[:stdin]
    stderr.print "single line:"
    args.shift.to_s.split("\0").first || stdin.gets.chomp
  end


  # opens a non-echoing prompt, if arg1 is nil or empty
  # args:
  # [ arg1 (String or nil)]
  def input_single_line_non_echo args=ARGV
    stderr = @memory[:stderr]
    stdin  = @memory[:stdin]
    require "io/console"
    stderr.print "non echo single line:"
    args.shift.to_s.split("\0").first || stdin.noecho{ stdin.gets}.chomp
  end


  # opens an echoing multiline prompt, if arg1 is nil or empty
  # args:
  # [ arg1 (String or nil)]
  def input_multi_line args=ARGV
    stderr = @memory[:stderr]
    stdin  = @memory[:stdin]
    stderr.print "multiline[control-D to stop]:"
    args.shift.to_s.split("\0").first || stdin.readlines.join
  end


  # opens a non-echoing multiline prompt, if arg1 is nil or empty
  # args:
  # [ arg1 (String or nil)]
  def input_multi_line_non_echo args=ARGV
    stderr = @memory[:stderr]
    stdin  = @memory[:stdin]
    require "io/console"
    stderr.print "multiline[control-D to stop]:"
    args.shift.to_s.split("\0").first || stdin.noecho{ stdin.readlines}.join.chomp
  end


  def input_shift_or_empty_string args=ARGV, default = ''
    args.shift || default
  end

  def input_shift args=ARGV
    args.shift
  end


  # outputs in such a way that it can be given
  # as an array of parameters via bash shell
  # not fully tested, use with caution.
  def output_array_to_shell args=ARGV
    args.map {|arg|
      "\"" << (arg && arg.to_s || "") << "\""
    }.join " "
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


  # planned changes:
  # use stdin from memory instead
  def shell_string_in_columns args=ARGV
    stderr = @memory[:stderr]
    time   = @memory[:time]
    number_of_columns = input_shift args
    text = input_non_empty_filepath_or_contents_or_multiline_prompt args
    puts (string_in_columns text, number_of_columns)
  end


  # print arguments given
  def main args=ARGV
    stderr = @memory[:stderr]
    time   = @memory[:time]
    puts args.join " "
  end


  # makes a rest request.
  # for now, the parameters must still be hardcoded.
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


  # generates (by default) a 128 bit key for a Cipher (e.g. AES)
  # args:
  # [ password, salt, iter, key_len ]
  # returns:
  # [key, password, salt, iter, key_len]
  #
  # planned changes:
  #  ensure that random_bytes == key_len
  def generate_pbkdf2_key args=ARGV
    require 'openssl'
    password, salt, iter, key_len = args
    iter = (iter.to_i > 0) && iter.to_i || 20000
    key_len = (salt.to_s.split("\0").first && salt.to_s.size > 0 && salt.size || 16)
    salt = salt.to_s.split("\0").first || OpenSSL::Random.random_bytes(key_len)
    key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(password.to_s, salt.to_s, iter.to_i, key_len.to_i)
    [key, password, salt, iter, key_len]
  end


  # decrypt encrypted (string), having password (string), iv (string),
  # big_file(bool) is a flag to set padding to 0.
  #
  # planned changes:
  # add metadata information to encrypted
  # decipher.key = Digest::SHA256.hexdigest is not the best security.
  # encrypted could be called base64_encrypted
  # iv could be called base64_iv
  # get only one string, not encrypted and iv (see enc planned changes)
  # remove dependence on the uniqueness of ending
  #
  def dec args=ARGV
    require 'openssl'
    require 'base64'
    memory = @memory
    static_end_key = memory[:static_end_key]
    password, iv, encrypted, ending, base64_salt, base64_iter = args
    salt = Base64.decode64 base64_salt
    iter = Base64.decode64 base64_iter
    ending = ending.to_s.split("\0").first || static_end_key
    key, password, salt, iter =  (
      generate_pbkdf2_key [password, salt, iter]
    )|| [nil, password, salt, iter]

    decipher = OpenSSL::Cipher.new('aes-128-cbc')
    decipher.decrypt
    decipher.padding = 0

    decipher.key = key || (Digest::SHA256.hexdigest password)
    decipher.iv = Base64.decode64 iv
    plain = decipher.update(Base64.decode64 encrypted) + decipher.final
    # split is not the ideal, if ever ending is duplicated it won't
    # work. also may be innefficient.
    (plain.split ending).first

  end


  # prompts for arguments to dec function
  # args:
  # [ iv, encrypted, password ] (all Strings)
  # returns:
  #  [password, encrypted, iv] (all Strings)
  # planned changes:
  # call separate functions.
  #
  def shell_dec_input args=ARGV
    require 'stringio'
    require "io/console"
    memory = @memory
    debug  = memory[:debug]
    stderr = memory[:stderr]
    stdout = memory[:stdout]
    stdin  = memory[:stdin]

    stderr.print "iv:"
    # basically => any string other than "" or the default one:
    iv = args.shift.to_s.split("\0").first
    iv = (url_to_str iv) || iv.to_s.split("\0").first || (url_to_str 'out.enc.iv.base64')
    debug && (stderr.puts iv)
    stderr.puts
    stderr.print "encrypted:"
    # basically => any string other than "" or the default one:
    encrypted = args.shift.to_s.split("\0").first
    encrypted = (url_to_str encrypted) || encrypted.to_s.split("\0").first  || (url_to_str 'out.enc.encrypted.base64')
    debug && (stderr.puts "#{encrypted}")
    stderr.puts
    stderr.print "password:"
    password = args.shift.to_s.split("\0").first || begin stdin.noecho{ stdin.gets}.chomp rescue gets.chomp end
    stderr.puts
    [password, encrypted, iv]
 end


  # and output the decrypted data to stdout.
  #
  # planned changes:
  # stop argument shifting.
  # call separate functions.
  #
  def shell_dec_output args=ARGV
    memory = @memory
    stdout = memory[:stdout]
    pw_plain, reserved_for_future = args
    stdout.puts pw_plain
  end


  # prompts for arguments to dec, calls dec,
  # and output the decrypted data to stdout.
  # args:
  # (forwarded to shell_dec_input, as of now:
  # returns:
  # nil
  #
  # planned changes:
  # stop argument shifting.
  # call separate functions.
  #
  def shell_dec args=ARGV
    require 'json'
    require 'base64'
    memory = @memory
    stderr = memory[:stderr]
    password, base64_json_serialized_data, iv_deprecated = shell_dec_input args
    metadata = JSON.parse Base64.decode64 base64_json_serialized_data
    base64_iv = metadata["base64_iv"]
    base64_encrypted = metadata["base64_encrypted"]
    base64_salt = metadata["base64_salt"]
    base64_iter = metadata["base64_iter"]
    base64_key  = metadata["base64_key" ]
    ending = nil
    pw_plain = dec [password, base64_iv, base64_encrypted, ending, base64_salt, base64_iter]
    shell_dec_output [pw_plain]
  end

  # encrypt data (string), with password (string)
  # returns [base64_iv, base64_encrypted]
  #
  # planned changes:
  # add metadata information to encrypted
  # return only one string, having encrypted + metadata (having iv)
  # add string length to metadata
  # decipher.key = Digest::SHA256.hexdigest is not the best security.
  #
  def enc args=ARGV
    require 'openssl'
    require 'base64'
    memory = @memory
    static_end_key = memory[:static_end_key]
    password, data, ending, salt, iter = args
    ending ||= static_end_key
    key, password, salt, iter = (
      generate_pbkdf2_key [password, salt, iter]
    )|| [nil, password, salt, iter]

    cipher = OpenSSL::Cipher.new('aes-128-cbc')
    cipher.encrypt

    cipher.key = key || (Digest::SHA256.hexdigest password)
    iv = cipher.random_iv
    encrypted = cipher.update(data + ending) + cipher.final

    base64_iv = Base64.encode64 iv
    base64_encrypted = Base64.encode64  encrypted
    base64_salt = Base64.encode64 salt.to_s
    base64_iter = Base64.encode64 iter.to_s
    base64_key = Base64.encode64 key.to_s

    [base64_encrypted, base64_iv,  base64_salt, base64_iter, base64_key]
  end


  # prompts for arguments to dec
  # args:
  # [ multiline_data, data_file, single_line_data, password, encrypted_base64_filename, enc_iv_base64_filename_deprecated] (all Strings)
  # returns:
  #   [password, data, encrypted_base64_filename, enc_iv_base64_filename_deprecated]
  #
  # planned changes:
  # call separate functions.
  # stop argument shifting.
  #
  def shell_enc_input args=ARGV
    memory = @memory
    stderr = @memory[:stderr]
    stdout = @memory[:stdout]
    stdin  = @memory[:stdin]
    debug = memory[:debug]
    require 'stringio'
    require "io/console"

    data = ""
    stderr.print "multi_line_data[ data 1/3, echoing, control-D to stop]:"
    data += args.shift ||  (stdin.readlines.join rescue readlines.join)
    stderr.puts
    stderr.print "data_file [data 2/3]:"
    data_file = args.shift ||  (stdin.gets.chomp rescue gets.chomp)
    data  += url_to_str data_file, ""
    stderr.puts
    stderr.print "single_line_data[data 3/3, no echo part]:"
    data += args.shift || begin stdin.noecho{ stdin.gets}.chomp rescue gets.chomp end
    stderr.puts
    stderr.print "password:"
    password = args.shift.to_s.split("\0").first || begin stdin.noecho{ stdin.gets}.chomp rescue gets.chomp end
    stderr.puts
    stderr.print "encrypted_base64_filename[default=out.enc.encrypted.base64]:"
    # basically => any string other than "" or the default one:
    encrypted_base64_filename = args.shift.to_s.split("\0").first || "out.enc.encrypted.base64"
    stderr.puts encrypted_base64_filename
    stderr.puts
    stderr.print "enc_iv_base64_filename[DEPRECATED]:"
    # basically => any string other than "" or the default one:
    enc_iv_base64_filename_deprecated = args.shift.to_s.split("\0").first || "out.enc.iv.base64"
    stderr.puts enc_iv_base64_filename_deprecated

    [password, data, encrypted_base64_filename, enc_iv_base64_filename_deprecated]
  end


  # outputs the results from enc
  def shell_enc_output args=ARGV
    memory = @memory
    stderr = memory[:stderr]
    base64_encrypted, base64_iv, encrypted_base64_filename, enc_iv_base64_filename_deprecated = args
    puts base64_iv
    puts base64_encrypted
    File.write  encrypted_base64_filename, base64_encrypted
    stderr.puts
  end


  # shell_enc
  # args
  # [password, data, encrypted_base64_filename, enc_iv_base64_filename_deprecated] (all Strings)
  # encrypts data using password and stores to encrypted_base64_filename
  # returns
  # nil
  #
  # planned changes:
  # encrypted_base64_filename
  def shell_enc args=ARGV
    require 'json'
    require 'base64'
    require 'openssl'
    password, data, encrypted_base64_filename, enc_iv_base64_filename_deprecated  = shell_enc_input args
    salt = nil
    iter = nil
    ending = nil
    base64_encrypted, base64_iv, base64_salt, base64_iter, base64_key = enc [password, data, ending, salt, iter]
    metadata = {
      "metadata"  => "Metadata",
      "base64_iv" => base64_iv,
      "base64_encrypted" => base64_encrypted,
      "base64_salt" => base64_salt,
      "base64_iter" => base64_iter,
    }
    base64_json_serialized_data =  Base64.encode64 JSON.pretty_generate metadata
    shell_enc_output [base64_json_serialized_data, base64_iv, encrypted_base64_filename ]
  end


  # serialize_json_metadata
  # args:
  # [payload (String), metadata (Hash), separator (String)]
  # prepends a JSON dump of metadata followed by separator
  # to a copy of payload, and returns it.
  def serialize_json_metadata args=ARGV
    require 'json'
    memory = @memory
    static_separator = memory[:static_separator_key]
    payload, metadata, separator = args
    metadata ||= { }
    separator ||= static_separator
    serialized_string = (JSON.pretty_generate metadata) + separator + payload
  end


  # deserialize_json_metadata
  # args:
  # [serialized_string (String), separator (String)]
  # undo what serialize_json_metadata
  # returns array:
  # [payload (String), metadata (Hash or String), separator (String)]
  # metadata is returned as Hash after a  JSON.parse, but in case
  # of any failure, it returns the String itself.
  def deserialize_json_metadata args=ARGV
    require 'json'
    memory = @memory
    static_separator = memory[:static_separator_key]
    serialized_string, separator = args
    separator ||= static_separator
    metadata_json, payload  = serialized_string.to_s.split separator
    metadata = (JSON.parse metadata_json) rescue metadata_json
    [payload, metadata, separator]
  end


  # test__json_metadata_serialization
  # sanity test for serialize_json_metadata and deserialize_json_metadata
  def test__json_metadata_serialization args=ARGV
    judgement = true
    payload = "Payload"
    # note: keys with : instead can't be recovered, because
    # they aren't described in JSON files
    metadata = { "metadata"  => "Metadata" }
    serialized = (serialize_json_metadata [payload, metadata ])
    new_payload, new_metadata = deserialize_json_metadata [serialized]
    judgement =
      [ [payload, new_payload, "payload"], [metadata, new_metadata, "metadata"]]
        .map(&method("expect_equal")).all?
  end


  # format strings for  expect_format_string
  def expect_format_string args=ARGV
    memory = @memory
    debug = memory[:debug]
    prepend_text, value_before, value_after, value_label, comparison_text = args
    "#{prepend_text} #{value_label}: #{value_before} #{comparison_text} #{value_after}"
  end


  # expect_equal
  # args:
  # [ value_before (Object), value_after (Object), value_label (String) ]
  # returns the value of testing value_before == value_after, printing to
  # stderr upon failure
  def expect_equal args=ARGV
    memory = @memory
    stderr = memory[:stderr]
    value_before, value_after, value_label = args
    judgement = (value_before == value_after)
    (!judgement) && (stderr.puts  expect_format_string ["unexpected", value_before, value_after, value_label, "!="])
    judgement
  end


  # test__shell_enc_dec
  # sanity test for shell_enc and shell_dec
  # planned changes:
  # don't output to stdout
  def test__shell_enc_dec args=ARGV
    shell_enc ["my secret",  "", "",  "tijolo22", "", ""]
    # shell_dec will read from the output file:
    judgement = ( shell_dec ["", "", "tijolo22"] || true) rescue false
  end


  # test for enc and dec.
  # "" and nil are expected to be treated
  # as the same.
  def test__enc_dec_nil args=ARGV
    nil_case = dec [nil, "ltUQIxgRAeUNXPNTTps8FQ==\n", "xyeqxw/TzkyXtOxpDqAl58SNAvXPyNZ89B5JGtwDkcbjo0vObgPsh5FrgZJs\nHPjofsyXnljnTrHpDoQeDVezo9wBZ74NU+TSi/GssX605oE=\n", nil, "TU4o3IKiFWki3rZ3lMchLQ==\n", "MjAwMDA=\n"]
    empty = dec ["", "ltUQIxgRAeUNXPNTTps8FQ==\n", "xyeqxw/TzkyXtOxpDqAl58SNAvXPyNZ89B5JGtwDkcbjo0vObgPsh5FrgZJs\nHPjofsyXnljnTrHpDoQeDVezo9wBZ74NU+TSi/GssX605oE=\n", "", "TU4o3IKiFWki3rZ3lMchLQ==\n", "MjAwMDA=\n"]
    judgement =
      [
        [nil_case, empty, "empty_nil_equality"]
      ].map(&method("expect_equal")).all?
  end


  # test for enc and dec and output_array_to_shell.
  # output_array_to_shell should create proper arguments
  #  to dec
  # TODO: invalid test -- that can't yet be ensured
  def test__enc_dec_shell_programatically args=ARGV
    stderr = @memory[:stderr]
    stderr.puts "test invalid; skip"
    shell = nil
    programatically = nil
    judgement =
      [
        [shell, programatically, "shell_programatically_equality"]
      ].map(&method("expect_equal")).all?
  end


  # test for enc and dec.
  # good idea is to use this function once with the desired
  # data, password, and use the stderr output
  def test__enc_dec args=ARGV
    stderr = @memory[:stderr]
    data, password = args
    stderr.print "[data]"
    data = input_multi_line_non_echo [data]
    stderr.print "[password]"
    password = input_single_line_non_echo [password]
    base64_encrypted, base64_iv, base64_salt, base64_iter, base64_key = enc [password, data]
    dec_args = [password, base64_iv, base64_encrypted, nil, base64_salt, base64_iter]
    stderr.puts "# programmatically:"
    stderr.puts "dec " + dec_args.to_s
    stderr.puts "# shell: "
    stderr.puts "#{$0} invoke_double p dec " + (output_array_to_shell dec_args).to_s
    data_plain = dec [password, base64_iv, base64_encrypted, nil, base64_salt, base64_iter]
    judgement =
      [
        [data, data_plain, "data"]
      ].map(&method("expect_equal")).all?
  end


  # gem_spec
  # args (Array like the one returned by rubyment_gem_defaults)
  # returns: a gem spec string accordingly to args
  def gem_spec args=ARGV
    memory = @memory
    gem_name,
    gem_version,
    gem_dir,
    gem_ext,
    gem_hifen,
    gem_date,
    gem_summary,
    gem_description,
    gem_authors,
    gem_email,
    gem_files,
    gem_homepage,
    gem_license,
    gem_validate_class,
    gem_validate_class_args,
    gem_validate_class_method = args

    contents =<<-ENDHEREDOC
Gem::Specification.new do |s|
  s.name        = '#{gem_name}'
  s.version     = '#{gem_version}'
  s.date        = '#{gem_date}'
  s.summary     = '#{gem_summary}'
  s.description = '#{gem_description}'
  s.authors     = #{gem_authors.inspect}
  s.email       = '#{gem_email}'
  s.files       = #{gem_files.inspect}
  s.homepage    = '#{gem_homepage}'
  s.license     = '#{gem_license}'
end
    ENDHEREDOC
    contents
  end


  # rubyment_gem_spec
  # args (Array, forwarded and transfomed by rubyment_gem_defaults)
  # returns: a gem spec string for Rubyment
  def rubyment_gem_spec args=ARGV
    memory = @memory
    gem_spec rubyment_gem_defaults args
  end


  # test for rubyment_gem_spec. outputs the contents
  # returned by that function.
  # args: none
  # returns: none
  def test__rubyment_gem_spec args=ARGV
    puts rubyment_gem_spec
  end



  # defaults for the rubyment gem
  # args:
  # [gem_name, gem_version, gem_dir, gem_ext, gem_hifen]
  # all Strings.
  # defaults:
  # ["rubyment", version [], memory[:running_dir],
  # ".gem", "-"]
  # returns:
  # [gem_name, gem_version, gem_dir, gem_ext, gem_hifen]
  #
  def rubyment_gem_defaults args=ARGV
    memory = @memory
    running_dir   = memory[:running_dir]
    basic_version = memory[:basic_version]
    major_version = memory[:major_version]

    gem_name,
    gem_version,
    gem_dir,
    gem_ext,
    gem_hifen,
    gem_date,
    gem_summary,
    gem_description,
    gem_authors,
    gem_email,
    gem_files,
    gem_homepage,
    gem_license,
    gem_validate_class,
    gem_validate_class_args,
    gem_validate_class_method,
    gem_is_current_file = args

    gem_name ||= "rubyment"
    gem_version ||= (version [])
    gem_dir ||= running_dir
    gem_ext ||= ".gem"
    gem_hifen ||= "-"
    gem_ext ||= "date"
    gem_date ||= "2018-04-23"
    gem_summary     ||= "a set of ruby helpers"
    gem_description ||= "a gem for keeping Rubyment, a set of ruby helpers"
    gem_authors     ||= ["Ribamar Santarosa"]
    gem_email       ||= 'ribamar@gmail.com'
    gem_files       ||= ["lib/rubyment.rb"]
    gem_homepage    ||=
      "http://rubygems.org/gems/#{gem_name}"
    gem_license     ||= 'GPL-3.0'
    gem_validate_class ||= "Rubyment"
    gem_validate_class_args ||= {:invoke => ["p", "installed and validated"] }
    gem_validate_class_method ||= "new"
    gem_is_current_file = true # this enables the possibility of building
    #  a gem for the calling file itself, but be aware that lib/gem_file.rb
    # is supposed to be overriden later.
    [
       gem_name,
       gem_version,
       gem_dir,
       gem_ext,
       gem_hifen,
       gem_date,
       gem_summary,
       gem_description,
       gem_authors,
       gem_email,
       gem_files,
       gem_homepage,
       gem_license,
       gem_validate_class,
       gem_validate_class_args,
       gem_validate_class_method,
       gem_is_current_file,
   ]
  end


  # returns the gem path given the params.
  # args:
  # [gem_name, gem_version, gem_dir, gem_ext, gem_hifen]
  # all Strings.
  # defaults:
  # ["rubyment", version [], memory[:running_dir],
  # ".gem", "-"]
  def gem_path args=ARGV
    gem_name, gem_version, gem_dir, gem_ext, gem_hifen = rubyment_gem_defaults args
    "#{gem_dir}/#{gem_name}#{gem_hifen}#{gem_version}#{gem_ext}"
  end


  # gem_build
  # args:
  # [gem_spec_path (String), gem_spec_contents (String), gem_is_current_file, gem_name]
  # returns:
  # console output of gem build (String)
  def gem_build args=ARGV
    gem_spec_path, gem_spec_contents, gem_is_current_file, gem_name  = args
    require 'fileutils'

    # this supposes that  the current file is listed by the
    # s.files
    # field of the specification. it is not currently checked.
    gem_is_current_file && (
      FileUtils.mkdir_p 'lib'
      file_backup "lib/#{gem_name}.rb", "lib/"
      save_file __FILE__, "lib/#{gem_name}.rb"
    )

    FileUtils.mkdir_p File.dirname gem_spec_path
    File.write gem_spec_path, gem_spec_contents || (File.read gem_spec_path)
    `gem build #{gem_spec_path}`
  end


  # test for gem_build: builds gem for this rubyment file
  # after it, these commands will install/uninstall it:
  # sudo gem install $PWD/rubyment-0.0.#{@memory[:basic_version]} ; gem list  | grep -i rubyment ; sudo gem uninstall  rubyment
  # dependee:
  #  test__gem_install_validate_uninstall
  # args:
  # [gem_spec_path (String), gem_spec_contents (String)]
  # returns: none
  # outputs of gem build (String)
  def test__gem_build args=ARGV
    require 'fileutils'
    FileUtils.mkdir_p 'lib'
    save_file __FILE__, 'lib/rubyment.rb'
    puts gem_build ["rubyment.spec", rubyment_gem_spec(args) ]
  end

  # gem_install
  # args:
  # [gem_spec (String)]
  # returns:
  # console output of gem install (String)
  def gem_install args=ARGV
    system_user_is_super = @memory[:system_user_is_super]
    gem_spec, user_install = args
    user_install ||= (!system_user_is_super) && "--user-install" || ""
    `gem install #{user_install}  #{gem_spec}`
  end

  # gem_push
  # args:
  # [gem_spec (String)]
  # returns:
  # console output of gem push (String)
  def gem_push args=ARGV
    gem_spec, future_arg = args
    `gem push #{gem_spec}`
  end

  # gem_uninstall
  # args:
  # [gem_spec (String)]
  # returns:
  # console output of gem uninstall (String)
  def gem_uninstall args=ARGV
    system_user_is_super = @memory[:system_user_is_super]
    gem_spec, user_install = args
    user_install ||= (!system_user_is_super) && "--user-install" || ""
    `gem uninstall #{user_install}  #{gem_spec}`
  end

  # gem_list
  # args:
  # [gem_spec (String)]
  # returns:
  # console output of gem install (String)
  def gem_list args=ARGV
    gem_spec, future_arg = args
    `gem list | grep #{gem_spec}`
  end

  # validate_require
  # requires a file/gem in the system
  # returns nil if not found
  # args:
  # [requirement (String), validator_class (Class or String or nil),
  #  validator_args (Array), validator_method (Method or String)]
  # returns:
  # Rubyment, true or false
  def validate_require args=ARGV
    stderr = @memory[:stderr]
    requirement, validator_class, validator_args, validator_method = containerize args
    validate_call = validator_class && true
    validator_class = to_class validator_class
    validator_method ||=  "new"
    begin
      require requirement
      validate_call && (object_method_args_call [validator_method, validator_class, validator_args]) || (!validate_call) && true
    rescue LoadError => e
      stderr.puts e
      nil
    end
  end

  # system_rubyment
  # requires a system's Rubyment and invoke it using args
  # args:
  # args (Array)
  # returns:
  # Rubyment or false
  def system_rubyment args=ARGV
    validate_require ['rubyment', 'Rubyment', {:invoke => args }]
  end

  # test for system_rubyment
  # dependee:
  #  test__gem_install_validate_uninstall
  # args:
  # args (Array or nil)
  # returns:
  # Rubyment or false
  def test__system_rubyment args=ARGV
    rubyment_args = (args.to_a.size > 0 && args) || ["main", "tested system_rubyment"]
    p validate_require ['rubyment', 'Rubyment', {:invoke => rubyment_args }]
  end


  # validate the installation of a gem
  # args rubyment_gem_defaults
  # but planned to change.
  # bug detected: require x won't reload the gem.
  # args (Array just like the one
  # returned by rubyment_gem_defaults)
  # returns:
  # true or false
  def gem_validate args=ARGV
    memory = @memory
    gem_defaults = rubyment_gem_defaults args
    gem_name,
    gem_version,
    gem_dir,
    gem_ext,
    gem_hifen,
    gem_date,
    gem_summary,
    gem_description,
    gem_authors,
    gem_email,
    gem_files,
    gem_homepage,
    gem_license,
    gem_validate_class,
    gem_validate_class_args,
    gem_validate_class_method,
    gem_is_current_file = gem_defaults
    puts gem_build [
      "#{gem_name}.spec",
      gem_spec(gem_defaults),
      gem_is_current_file,
      gem_name
    ]
    already_installed = (
      validate_require [
        gem_name,
        gem_validate_class,
        gem_validate_class_args,
        gem_validate_class_method,
      ]
    )
    sleep 1
    already_installed && (gem_uninstall [gem_name])
    puts gem_list [gem_name]
    p (gem_path [gem_name, gem_version])
    gem_install [(gem_path [gem_name, gem_version])]
    puts gem_list [gem_name]
    v = (
      validate_require [
        gem_name,
        gem_validate_class,
        gem_validate_class_args,
        gem_validate_class_method,
      ]
    )
    gem_uninstall [gem_name]
    already_installed && (gem_install [gem_name])
    v
  end


  # test for gem_build, gem_install, gem_list
  # system_rubyment, gem_uninstall
  # note that, if there is a "rubyment" gem
  # already installed, it will be temporarily
  # unavailable.
  # args:
  # args (Array or nil)
  # returns:
  # Rubyment or false
  def test__gem_build_install_validate_uninstall args=ARGV
    memory = @memory
    basic_version = memory[:basic_version]
    major_version = memory[:major_version]
    running_dir = memory[:running_dir]
    test__gem_build []
    already_installed = (system_rubyment ["p", "already installed"])
    sleep 1
    gem_uninstall ["rubyment"]
    puts gem_list ["rubyment"]
    gem_install ["#{running_dir}/rubyment-#{major_version}.#{basic_version}.gem"]
    puts gem_list ["rubyment"]
    v = test__system_rubyment []
    gem_uninstall ["rubyment"]
    already_installed && (gem_install ["rubyment"])
    v
  end


  # gets the api key needed to push gems to rubygems.
  # prompts for arguments when username or password
  # not provided.
  # args:
  # [username (String or nil), password (String or nil),
  # file_destination (String, "/dev/null" if empty/nil given)]
  # returns
  # key_contents (String)
  def gem_get_api_key args=ARGV
    require 'fileutils'
    username, password, file_destination = args
    username = input_single_line [username]
    password = input_single_line_non_echo [password]
    file_destination = file_destination.to_s.split("\0").first || "/dev/null"
    FileUtils.mkdir_p File.dirname file_destination
    key_contents = save_file "https://rubygems.org/api/v1/api_key.yaml",
      file_destination, 0, {:username => username, :password => password }
    (File.chmod 0600, file_destination)
    key_contents
  end


  # test for test__gem_get_api_key
  # args:
  # (Array - forwarded to gem_get_api_key)
  # returns:
  # nil
  def test__gem_get_api_key args=ARGV
    puts gem_get_api_key args
  end

  # test for gem_build, gem_install, gem_list
  # system_rubyment, gem_uninstall
  # args:
  # args (Array or nil)
  # returns:
  # Rubyment or false
  def test__gem_complete_flow args=ARGV
    memory = @memory
    running_dir      = memory[:running_dir]
    home_dir         = memory[:home_dir]
    basic_version    = memory[:basic_version]
    major_version    = memory[:major_version]
    gem_api_key_file = "#{home_dir}/.gem/credentials"
    permissions = file_permissions_octal gem_api_key_file
    credentials_contents = url_to_str gem_api_key_file, ""
    gem_get_api_key [args[0], args[1], gem_api_key_file]
    validated = test__gem_build_install_validate_uninstall []
    puts validated && (gem_push ["#{running_dir}/rubyment-#{major_version}.#{basic_version}.gem"])
    File.write gem_api_key_file, credentials_contents
    File.chmod permissions, gem_api_key_file
  end


end

(__FILE__ == $0) && Rubyment.new({:invoke => ARGV})

