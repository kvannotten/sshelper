require "sshelper/version"
require "sshelper/hash"
require "net/ssh"
require "json"
require "fileutils"

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
      Net::SSH.start(server.host, server.user, :port => port) do |ssh|
        cd_cmd = nil
        @config[label].commands.each do |command|
          puts "Executing #{command} on #{server.host}"
          if command.start_with? "cd " then
            cd_cmd = command
            next
          end
          cmds = []
          cmds << cd_cmd unless cd_cmd.nil?
          cmds << command
          puts ssh.exec!(cmds.join(' && '))
        end
      end
    end
    
  end
  
  def self.configuration
    @config
  end

end
