require 'xcodeproj'
require 'colors'

module Longbow

  def self.update_target directory, target, global_keys, info_keys
    # Find Project File
    project_paths = []
    Dir.foreach(directory) do |fname|
      project_paths << fname if fname.include? '.xcodeproj'
    end

    # Open The Project
    return false if project_paths.length == 0
    proj = Xcodeproj::Project.open(project_paths[0])

    # Get Main Target's Basic Info
    @target = nil
    proj.targets.each do |t|
      if t.to_s == target
        @target = t
        Longbow::green '  ' + target + ' found.' if $verbose
      end
    end

    # Create Target if Necessary
    main_target = proj.targets.first
    @target = create_target(proj, target) unless @target

    # Plist Creating/Adding
    main_plist = main_target.build_configurations[0].build_settings['INFOPLIST_FILE']
    main_plist_contents = File.read(directory + '/' + main_plist)
    target_plist_path = directory + '/' + main_plist.split('/')[0] + '/' + target + '-info.plist'
    plist_text = main_plist_contents
    [info_keys,global_keys].each do |keys|
      keys.each_key do |k|
        value = keys[k]
        matches = plist_text.match /<key>#{k}<\/key>\s*<string>.*<\/string>/
        if matches
          plist_text = plist_text.sub(matches[0], "<key>" + k + "</key>\n<string>" + value + "</string>")
        else
          plist_text = plist_text.sub(/<\/dict>\s*<\/plist>/, "<key>" + k + "</key>\n<string>" + value + "</string></dict></plist>")
        end
      end
    end
    File.open(target_plist_path, 'w') do |f|
      f.write(plist_text)
    end


    # Add Build Settings
    @target.build_configurations.each do |b|
      # Main Settings
      main_settings = nil
      main_target.build_configurations.each do |bc|
        main_settings = bc.build_settings if bc.to_s == b.to_s
      end
      settings = b.build_settings
      main_settings.each_key do |key|
        settings[key] = main_settings[key]
      end

      # Plist & Icons
      settings['INFOPLIST_FILE'] = main_plist.split('/')[0] + '/' + target + '-info.plist'
      settings['ASSETCATALOG_COMPILER_APPICON_NAME'] = target

      if File.exists? directory + '/Pods'
        settings['PODS_ROOT'] = '${SRCROOT}/Pods'
        settings['HEADER_SEARCH_PATHS'] = ['${PODS_ROOT}/Headers/**']
      end
    end

    # Save The Project
    proj.save
  end

  def self.create_target project, target
    main_target = project.targets.first
    deployment_target = main_target.deployment_target

    # Create New Target
    new_target = Xcodeproj::Project::ProjectHelper.new_target project, :application, target, :ios, deployment_target, project.products_group
    if new_target
      # Add Build Phases
      main_target.build_phases.objects.each do |b|
        if b.isa == 'PBXSourcesBuildPhase'
          b.files_references.each do |f|
            new_target.source_build_phase.add_file_reference f
          end
        elsif b.isa == 'PBXFrameworksBuildPhase'
          b.files_references.each do |f|
            new_target.frameworks_build_phase.add_file_reference f
          end
        elsif b.isa == 'PBXResourcesBuildPhase'
          b.files_references.each do |f|
            new_target.resources_build_phase.add_file_reference f
          end
        elsif b.isa == 'PBXShellScriptBuildPhase'
          phase = new_target.new_shell_script_build_phase(name = b.display_name)
          phase.shell_script = b.shell_script
        end
      end

      Longbow::green '  ' + target + ' created.' if $verbose
    else
      puts
      Longbow::red '  Target Creation failed for target named: ' + target
      puts
    end

    return new_target
  end

end