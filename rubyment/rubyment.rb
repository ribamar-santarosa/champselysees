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
      :stdout => STDOUT,
      :stdin  => STDIN,
      :time   => Time.now,
      :basic_version => (Time.now.to_i  / 60), # new one every minute
      :filepath => __FILE__,
      :running_dir => Dir.pwd,
      :static_separator_key => "strings_having_this_string_not_guaranteed_to_work",
      :static_end_key => "strings_havinng_this_string_also_not_guaranteed_to_work",
    }
    @memory.update memory
    invoke = @memory[:invoke].to_a
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
      self.method(invoke[0]).call (invoke[1..-1])
    rescue ArgumentError => e
      self.method(invoke[0]).call *(invoke[1..-1])
    end
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


  # opens an echoing prompt, if arg1 is string
  # args:
  # [ arg1 (String or nil)]
  def input_single_line args=ARGV
    stderr = @memory[:stderr]
    stdin  = @memory[:stdin]
    stderr.print "single line:"
    args.shift.to_s.split("\0").first || stdin.gets.chomp
  end


  # opens a non-echoing prompt, if arg1 is string
  # args:
  # [ arg1 (String or nil)]
  def input_single_line_non_echo args=ARGV
    stderr = @memory[:stderr]
    stdin  = @memory[:stdin]
    require "io/console"
    stderr.print "non echo single line:"
    args.shift.to_s.split("\0").first || stdin.noecho{ stdin.gets}.chomp
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
    ending ||= static_end_key
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
    data += args.shift.to_s.split("\0").first || begin stdin.noecho{ stdin.gets}.chomp rescue gets.chomp end
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
    judgement = ( shell_dec ["", "", "tijolo22"] || true) rescue false
  end

  # rubyment_gem_spec
  # args: none
  # returns: a gem spec string for Rubyment
  def rubyment_gem_spec args=ARGV
    memory = @memory
    basic_version = memory[:basic_version]
    contents =<<-ENDHEREDOC
Gem::Specification.new do |s|
  s.name        = 'rubyment'
  s.version     = '0.0.#{basic_version}'
  s.date        = '2018-04-23'
  s.summary     = "a set of ruby helpers"
  s.description = "a gem for keeping Rubyment, a set of ruby helpers"
  s.authors     = ["Ribamar Santarosa"]
  s.email       = 'ribamar@gmail.com'
  s.files       = ["lib/rubyment.rb"]
  s.homepage    =
    'http://rubygems.org/gems/rubyment'
  s.license       = 'GPL-3.0'
end
    ENDHEREDOC
    contents
  end

  # test for rubyment_gem_spec. outputs the contents
  # returned by that function.
  # args: none
  # returns: none
  def test__rubyment_gem_spec args=ARGV
    puts rubyment_gem_spec
  end

  # gem_build
  # args:
  # [gem_spec_path (String), gem_spec_contents (String)]
  # returns:
  # console output of gem build (String)
  def gem_build args=ARGV
    gem_spec_path, gem_spec_contents  = args
    require 'fileutils'
    FileUtils.mkdir_p File.dirname gem_spec_path
    File.write gem_spec_path, gem_spec_contents || (File.read gem_spec_path)
    `gem build #{gem_spec_path}`
  end

  # test for gem_build: builds gem for this rubyment file
  # after it, these commands will install/uninstall it:
  # sudo gem install $PWD/rubyment-0.0.#{@memory[:basic_version]} ; gem list  | grep -i rubyment ; sudo gem uninstall  rubyment
  # args:
  # [gem_spec_path (String), gem_spec_contents (String)]
  # returns: none
  # outputs of gem build (String)
  def test__gem_build args=ARGV
    require 'fileutils'
    FileUtils.mkdir_p 'lib'
    save_file __FILE__, 'lib/rubyment.rb'
    puts gem_build ["rubyment.spec", rubyment_gem_spec ]
  end

  # gem_install
  # args:
  # [gem_spec (String)]
  # returns:
  # console output of gem install (String)
  def gem_install args=ARGV
    gem_spec, future_arg = args
    `gem install #{gem_spec}`
  end

  # gem_uninstall
  # args:
  # [gem_spec (String)]
  # returns:
  # console output of gem uninstall (String)
  def gem_uninstall args=ARGV
    gem_spec, future_arg = args
    `gem uninstall #{gem_spec}`
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

  # system_rubyment
  # requires a system's Rubyment and invoke it using args
  # args:
  # args (Array)
  # returns:
  # Rubyment or false
  def system_rubyment args=ARGV
    begin
      require 'rubyment'
      Rubyment.new({:invoke => args })
    rescue LoadError
      nil
    end
  end

  # test for system_rubyment
  # args:
  # args (Array or nil)
  # returns:
  # Rubyment or false
  def test__system_rubyment args=ARGV
    rubyment_args = (args.to_a.size > 0 && args) || ["main", "tested system_rubyment"]
    p system_rubyment rubyment_args
  end


  # test for gem_build, gem_install, gem_list
  # system_rubyment, gem_uninstall
  # args:
  # args (Array or nil)
  # returns:
  # Rubyment or false
  def test__gem_build_install_validate_uninstall args=ARGV
    memory = @memory
    basic_version = memory[:basic_version]
    running_dir = memory[:running_dir]
    test__gem_build []
    gem_uninstall ["rubyment"]
    puts gem_list ["rubyment"]
    gem_install ["#{running_dir}/rubyment-0.0.#{basic_version}.gem"]
    puts gem_list ["rubyment"]
    v = test__system_rubyment []
    gem_uninstall ["rubyment"]
    v
  end

end

(__FILE__ == $0) && Rubyment.new({:invoke => ARGV})

