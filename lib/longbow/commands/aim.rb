require 'fileutils'
require 'longbow/colors'
require 'longbow/targets'
require 'longbow/images'
require 'longbow/json'
require 'json'

command :aim do |c|
  c.syntax = 'longbow aim'
  c.syntax = 'Takes screenshots for each target in your workspace or project based on a UIAutomation script.'
  c.description = ''
  c.option '-s', '--script SCRIPT', 'Script used to get the app into the proper state for each screenshot'
  c.option '-d', '--directory DIRECTORY', 'Path where the .xcodeproj or .xcworkspace file && the longbow.json file live.'
  c.option '-u', '--url URL', 'URL of a longbow formatted JSON file.'
  c.option '-n', '--name NAME', 'Name of the target to get a screenshot for.'

  c.action do |args, options|
    # Check for newer version
    Longbow::check_for_newer_version unless $nolog

    # Set Up
    @script = options.script ? options.script : nil
    @directory = options.directory ? options.directory : Dir.pwd
    @url = options.url ? options.url : nil
    @target_name = options.name
    @targets = []

    # Create JSON object
    if @url
      obj = Longbow::json_object_from_url @url
    else
      obj = Longbow::json_object_from_directory @directory
    end

    # Break if Bad
    unless obj || Longbow::lint_json_object(obj)
      Longbow::red "\n Invalid JSON. Please lint the file, and try again.\n"
      next
    end

    # Check for Target Name
    if @target_name
      obj['targets'].each do |t|
        @targets << t if t['name'] == @target_name
      end

      if @targets.length == 0
        Longbow::red "\n  Couldn't find a target named #{@target_name} in the longbow.json file.\n"
        next
      end
    else
      @targets = obj['targets']
    end

    resources_path = File.dirname(__FILE__) + '/../../../resources'

    FileUtils.cp "#{resources_path}/capture.js", "capture.js"

    @targets.each do |t|
      Longbow::blue "  Running screenshooter for #{t['name']}"
      begin
        `#{resources_path}/ui-screen-shooter.sh ~/Desktop/screenshots/#{t['name']} #{t['name']} #{@script}`
      rescue
        Longbow::red "Failed while running screenshooter for #{t['name']}"
      end
    end

    FileUtils.rm "capture.js"
  end
end
