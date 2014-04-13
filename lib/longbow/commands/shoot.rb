$:.push File.expand_path('../../', __FILE__)
require 'fileutils'
require 'longbow/colors'
require 'longbow/targets'
require 'longbow/images'
require 'json'

command :shoot do |c|
  c.syntax = 'longbow shoot [options]'
  c.summary = 'Creates/updates a target or all targets in your workspace or project.'
  c.description = ''
  c.option '-n', '--name NAME', 'Target name from the corresponding longbow.json file.'
  c.option '-d', '--directory DIRECTORY', 'Path where the .xcodeproj or .xcworkspace file && the longbow.json file live.'

  c.action do |args, options|
    # Set Up
    @target_name = options.name ? options.name : nil
    @directory = options.directory ? options.directory : Dir.pwd
    @targets = []

    # Check for .longbow.json
    @json_path = @directory + '/longbow.json'
    if !File.exists?(@json_path)
      puts
      Longbow::red "  Couldn't find longbow.json at " + @json_path
      puts
      puts "  Run this command to install the correct files:"
      puts "  longbow install"
      puts
      next
    end

    # Create an Object from JSON
    json_contents = File.open(@json_path).read
    unless !!JSON.parse(json_contents)
      Longbow::red '  Invalid JSON - lint it, and try again.'
      next
    end
    obj = JSON.parse(json_contents)

    # Check for Target Name
    if @target_name
      obj['targets'].each do |t|
        @targets << t if t['name'] == @target_name
      end

      if @targets.length == 0
        puts
        Longbow::red "  Couldn't find a target named " + @target_name + " in the .longbow.json file."
        puts
        next
      end
    else
      obj['targets'].each do |t|
        @targets << t
      end
    end

    # Begin
    @targets.each do |t|
      Longbow::update_target @directory, t['name'], obj['global_info_keys'], t['info_plist']
      Longbow::create_images @directory, t, obj
      Longbow::green '  Finished: ' + t['name'] unless $nolog
      puts unless $nolog
    end
  end
end