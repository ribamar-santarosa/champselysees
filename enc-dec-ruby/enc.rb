#!/usr/bin/ruby

class ProjectExecution

  def file_backup file = __FILE__ , dir = '/tmp/', append = ('-' + Time.now.hash.abs.to_s)
    contents = File.read file
    File.write (dir + '/' + file + append), contents
    contents
  end

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
    STDERR.print "enc_iv_base64_filename[default=out.enc.iv.base64]:"
    # basically => any string other than "" or the default one:
    enc_iv_base64_filename = args.shift.to_s.split("\0").first || "out.enc.iv.base64"
    STDERR.puts
    STDERR.print "encrypted_base64_filename[default=out.enc.encrypted.base64]:"
    # basically => any string other than "" or the default one:
    encrypted_base64_filename = args.shift.to_s.split("\0").first || "out.enc.encrypted.base64"
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


