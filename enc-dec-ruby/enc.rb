#!/usr/bin/env ruby

=begin
# Deprecation Note:
`enc-dec-ruby`: both `dec.rb` and `enc.rb` are outdated in favour of
`rubyment`'s `shell_dec` and `shell_enc`. Files left for API contract,
but not a good idea to start using them.
=end

class ProjectExecution

  def file_backup file = __FILE__ , dir = '/tmp/', append = ('-' + Time.now.hash.abs.to_s)
    require 'fileutils'
    contents = File.read file
    location = dir + '/' + file + append
    FileUtils.mkdir_p File.dirname location # note "~" doesn't work
    File.write location, contents
    contents
  end



  def url_to_str url, rescue_value=nil
  require 'open-uri'
    contents = open(url).read rescue rescue_value
  end

  def enc args=ARGV
    require 'openssl'
    require 'stringio'
    require 'open-uri'
    require 'curb'
    require 'base64'
    require "io/console"

    data = ""
    STDERR.print "multi_line_data[ data 1/3, echoing, control-D to stop]:"
    data += args.shift ||  readlines.join
    STDERR.puts
    STDERR.print "data_file [data 2/3]:"
    data_file = args.shift ||  (gets.chomp rescue "")
    data  += url_to_str data_file, ""
    STDERR.puts
    STDERR.print "single_line_data[data 3/3, no echo part]:"
    data += args.shift || (begin STDIN.noecho{ gets}.chomp rescue gets.chomp end)
    STDERR.puts
    STDERR.print "password:"
    # password = args.shift.to_s.split("\0").first
    # password = args.shift.to_s.split("\0").first || gets.chomp
    # password = args.shift.to_s.split("\0").first || STDIN.noecho{ STDIN.gets}.chomp
    # password = args.shift.to_s.split("\0").first || STDIN.noecho{ gets}.chomp
    # password = args.shift.to_s.split("\0").first || begin STDIN.noecho{ gets}.chomp rescue gets.chomp end
    password = args.shift.to_s.split("\0").first || begin STDIN.noecho{ STDIN.gets}.chomp rescue gets.chomp end
    # puts "password: [#{password}]"
    # password ||= STDIN.gets.chomp
    STDERR.puts
    STDERR.print "encrypted_base64_filename[default=out.enc.encrypted.base64]:"
    # basically => any string other than "" or the default one:
    encrypted_base64_filename = args.shift.to_s.split("\0").first || "out.enc.encrypted.base64"
    STDERR.puts encrypted_base64_filename
    STDERR.puts
    STDERR.print "enc_iv_base64_filename[default=out.enc.iv.base64]:"
    # basically => any string other than "" or the default one:
    enc_iv_base64_filename = args.shift.to_s.split("\0").first || "out.enc.iv.base64"
    STDERR.puts enc_iv_base64_filename
    STDERR.puts


    cipher = OpenSSL::Cipher.new('aes-128-cbc')
    cipher.encrypt
    key = cipher.key = Digest::SHA256.hexdigest password
    iv = cipher.random_iv
    encrypted = cipher.update(data) + cipher.final

    base64_iv = Base64.encode64 iv
    base64_encrypted = Base64.encode64  encrypted

    puts base64_iv
    puts base64_encrypted
    File.write  enc_iv_base64_filename, base64_iv
    File.write  encrypted_base64_filename, base64_encrypted
    # File.write  'out.enc.iv', iv
    # File.write  'out.enc.iv.base64', base64_iv
    # File.write  'enc.encrypted', encrypted
    # File.write  'out.enc.encrypted.base64', base64_encrypted

  end

  def main args=ARGV
    file_backup
    enc args
  end
end

ProjectExecution.new.main


