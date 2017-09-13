#!/usr/bin/ruby

class ProjectExecution

  def url_to_str url
  require 'open-uri'
    contents = open(url).read
  end

  def enc args=ARGV
    require 'openssl'
    require 'stringio'
    require 'open-uri'
    require 'curb'
    require 'base64'
    require "io/console"

    data = ""
    print "multi_line_data[ data 1/3, echoing, control-D to stop]:"
    data += args.shift ||  readlines.join
    STDERR.puts
    print "data_file [data 2/3]:"
    data_file = args.shift ||  gets.chomp rescue ""
    data  += url_to_str data_file rescue  ""
    STDERR.puts
    print "single_line_data[data 3/3, no echo part]:"
    data += args.shift || begin STDIN.noecho{ gets}.chomp rescue gets.chomp end
    STDERR.puts
    STDERR.print "password:"
    password = args.shift || begin STDIN.noecho{ gets}.chomp rescue gets.chomp end
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
    File.write  'enc.iv', iv
    File.write  'enc.iv.base64', base64_iv
    File.write  'enc.encrypted', encrypted
    File.write  'enc.encrypted.base64', base64_encrypted

  end

  def main args=ARGV
    enc args
  end
end

ProjectExecution.new.main


