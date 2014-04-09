$:.push File.expand_path('../../', __FILE__)
require 'fileutils'
require 'longbow/colors'
require 'longbow/targets'
require 'json'

command :create do |c|
  c.syntax = 'longbow create [options]'
  c.summary = 'Creates a target in your workspace or project'
  c.description = ''

  c.option '-n', '--name NAME', 'Target name from the corresponding .longbow.json file.'
  c.option '-d', '--directory DIRECTORY', 'Path where the .xcproj or .xcworkspace file && the .longbow.json file live.'

  c.action do |args, options|
    # Set Up
    @target_name = options.name ? options.name : nil
    @directory = options.directory ? options.directory : Dir.pwd
    @targets = []

    # Check for .longbow.json
    @json_path = @directory + '/.longbow.json'
    if !File.exists?(@json_path)
      puts
      Longbow::red "Couldn't find .longbow.json at " + @json_path
      puts
      puts "Run this command to install the correct files:"
      puts "longbow install"
      puts
      next
    end

    # Check for Target Name
    json_contents = File.open(@json_path).read
    obj = JSON.parse(json_contents)
    if @target_name
      obj['targets'].each do |t|
        @targets << t['name'] if t['name'] == @target_name
      end

      if @targets.length == 0
        puts
        Longbow::red "Couldn't find a target named " + @target_name + " in the .longbow.json file."
        puts
        next
      end
    else
      obj['targets'].each do |t|
        @targets << t['name']
      end
    end

    # Begin
    @targets.each do |t|
      Longbow::update_target @directory, t
    end
  end
end