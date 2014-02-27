$:.push File.expand_path('../../', __FILE__)
require 'fileutils'

command :install do |c|
  c.syntax = 'longbow install [options]'
  c.summary = 'Creates the required files in your directory.'
  c.description = ''
  c.option '-d', '--directory DIRECTORY', 'Path where the .xcproj or .xcworkspace file && the .longbow.json file live.'

  c.action do |args, options|
    @directory = options.directory ? options.directory : Dir.pwd
    @json_path = @directory + '/.longbow.json'
    @screens_path = @directory + '/.longbow.screens'

    if File.exist?(@json_path)
      puts '  .longbow.json already exists at ' + @json_path
    else
      File.open(@directory + '/.longbow.json', 'w') do |f|
        f.write('{"TargetName":{"icon_url":"https://somewhere.net/img.png", "info_plist":{"CFBundleId":"com.company.target"}}}')
      end
      puts '  .longbow.json created'
    end

    if File.exist?(@screens_path)
      puts '  .longbow.screens already exists at ' + @screens_path
    else
      File.open(@directory + '/.longbow.screens', 'w') {}
      puts '  .longbow.screens created'
    end
  end
end