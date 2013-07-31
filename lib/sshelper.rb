require "sshelper/version"
require "sshelper/hash"
require "sshelper/string"
require 'rye'
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
      puts "Creating SSH session on #{server.host}...".pink
      rbox = Rye::Box.new( server.host, :user => server.user, :port => port, :safe => false )
      
      puts "Logged in! Executing commands...".pink
      @config[label].commands.each do |command|
        puts "\nExecuting: #{command}".red
        puts '#### OUTPUT ####'.blue
        if command.start_with? "cd" then
          rbox.cd command.split(' ', 2).last
        else
          puts "#{rbox.execute(command).stdout.map{ |k| "~> #{k}" }.join("\n") }"
        end
        puts '#### END ####'.blue
      end
    end 
  end
  
  def self.configuration
    @config
  end

end
