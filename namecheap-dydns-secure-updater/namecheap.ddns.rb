#!/usr/bin/ruby

class ProjectExecution
  require 'openssl'
  require 'stringio'
  require 'open-uri'
  require 'curb'
  require 'base64'
  require "io/console"

  def save_file url, location, wtime=0
  require 'open-uri'
   require 'fileutils'
   FileUtils.mkdir_p File.dirname location # note "~" doesn't work
    contents = open(url).read
    r = File.write location, contents
    sleep wtime
    contents
  end

  def url_to_str url
  require 'open-uri'
    contents = open(url).read
  end

  def dec args=ARGV
    password, iv, encrypted = args
    decipher = OpenSSL::Cipher.new('aes-128-cbc')
    decipher.decrypt
    decipher.key = Digest::SHA256.hexdigest password
    decipher.iv = Base64.decode64 iv
    plain = decipher.update(Base64.decode64 encrypted) + decipher.final
  end


  def dyndns_update args=ARGV
    domain, host, password, iv, encrypted = args
    pw_plain = dec [password, iv, encrypted]
    ip = url_to_str url  rescue "127.0.0.1" # localhost if no connection

    update_url = "https://dynamicdns.park-your-domain.com/update?host=#{host}&domain=#{domain}&password=#{pw_plain}&ip=#{ip}"

    execution_id=Time.now.hash.abs.to_s
    puts save_file update_url, location="output.execution_id_is_#{execution_id}"
  end

  def main args=ARGV

    STDERR.print "domain:"
    domain = args.shift || ''
    STDERR.puts
    STDERR.print "host:"
    host = args.shift || ''
    host = (host.size > 0) && host || '@' #  @ to TLD or top level domain default
    STDERR.puts
    STDERR.print "iv:"
    iv = args.shift || ''
    iv= (iv.size > 0) && iv || (url_to_str 'enc.iv.base64')
    STDERR.puts
    STDERR.print "encrypted:"
    encrypted = args.shift || ''
    encrypted = (encrypted.size > 0) && host || (url_to_str 'enc.encrypted.base64')
    STDERR.puts
    STDERR.print "password:"
    password = args.shift || begin STDIN.noecho{ gets}.chomp rescue gets.chomp end
    STDERR.puts
    dyndns_update [domain, host, password, iv, encrypted]

  end
end

ProjectExecution.new.main
