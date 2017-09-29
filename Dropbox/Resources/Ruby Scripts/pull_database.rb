#!/usr/bin/ruby
require 'rubygems'
require 'net/ssh'

def pbcopy(input)
 str = input.to_s
 IO.popen('pbcopy', 'w') { |f| f << str }
 str
end

def cmd(cmd)
  res = @ssh.exec!(cmd)
  puts res
end

puts "Database name (remote):"
remote_db_name = gets.chomp
now = Time.now.strftime('%Y%m%d')

@host = "104.131.52.171"
@username = "root"
@password = "r5tgbhu8I"
@port = "911"
@ssh = nil

begin
  @ssh = Net::SSH.start(@host, @username, password: @password, port: @port)

  cmd("ls")
  cmd("pwd")
  cmd("whoami")
  cmd("su postgres")
  cmd("whoami")
  cmd("pwd")
  cmd("cd ~/")
  cmd("pwd")

  # puts res

  ssh.close
rescue e
  puts "Unable to connect to #{@hostname} using #{@username}/#{@password}"
  puts e
end













if %w(y 1).include? gets.chomp.downcase

else

end

