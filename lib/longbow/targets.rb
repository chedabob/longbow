require 'xcodeproj'
require 'colors'

module Longbow

  def self.update_target directory, target
    # Find Workspace/Project File
    workspace_paths = []
    project_paths = []
    Dir.foreach(directory) do |fname|
      workspace_paths << fname if fname.include? '.xcworkspace'
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
        puts target + ' FOUND'
      end
    end

    # Create Target if Necessary
    @target = create_target(proj, target) unless @target

    # Save The Project
    proj.save
  end

  def self.create_target project, target
    main_target = project.targets.first
    deployment_target = main_target.deployment_target

    # Create New Target
    new_target = Xcodeproj::Project::ProjectHelper.new_target project, :application, target, :ios, deployment_target, project.products_group
    if new_target
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
    else
      puts
      Longbow::Red 'Target Creation failed for target named: ' + target
      puts
    end

    return new_target
  end

end