require "sshelper/version"
require "sshelper/hash"
require "sshelper/string"
require "net/ssh"
require "net/ssh/telnet"
require "json"
require "fileutils"
require "socket"

module Sshelper
  @config
  
  def self.prepare!
    raise "Needs configuration file" unless File.exists? File.expand_path("~/.sshelper.json")
    
    begin 
      @config ||= JSON.parse IO.read(File.expand_path("~/.sshelper.json"))
    rescue
      puts "An error occurred while parsing your configuration file."
    end
  end
  
  def self.execute_label label = nil
    return if label.nil?
    labels = @config.map { |key, value| key }
    if not labels.include? label then
      puts "Could not find that label."
      return
    end
    
    if not @config[label].include? "servers" or not @config[label].include? "commands" then
      puts "The configuration file does not contain a 'servers' array or a 'commands' array"
      return
    end
    
    if not @config[label].servers.is_a? Array or not @config[label].commands.is_a? Array then
      puts "The servers and commands block need to be arrays."
      return
    end
    
    @config[label].servers.each do |server|
      port = (server.include?("port") ? server.port : 22)
      ssh = Net::SSH.start(server.host, server.user, :port => port)
      s = Net::SSH::Telnet.new("Session" => ssh)
      puts "Logged in".pink
      @config[label].commands.each do |command|
        puts "\nExecuting: #{command}".red
        puts '#### OUTPUT ####'.blue
        puts "#{s.cmd(command).split("\n").join("\n ~> ")}"
        puts '#### END ####'.blue
      end
      s.close
      ssh.close
    end   
  end
  
  def self.configuration
    @config
  end

end
