$:.push File.expand_path('../', __FILE__)
require 'mini_magick'
require 'colors'
require 'xcodeproj'
require 'open-uri'

module Longbow

  # Resize Icon
  def self.resize_icons(directory, t, obj)
    # Bad Params
    if !directory || !t
      return false
    end

    # Set Up
    target = t['name']

    # Get Device Information
    iPhone = false
    iPad = false
    if obj['devices']
      obj['devices'].each do |d|
        iPhone = true if d == 'iPhone'
        iPad = true if d == 'iPad'
      end
    end

    # Get Image Information
    img_path = ''
    if t['icon_url']
      img_path = self.path_for_downloaded_image_from_url directory, target, t['icon_url']
    elsif t['icon_path']
      img_path = directory + '/' + t['icon_path']
    end

    # Make directory
    img_dir = make_asset_directory directory, target

    # Make image
    image = MiniMagick::Image.open(img_path)
    return false unless image

    # Size for iPhone
    if iPhone
      image.resize '120x120'
      image.write  img_dir + '/icon120x120.png'
      image.resize '114x114'
      image.write  img_dir + '/icon114x114.png'
      image.resize '80x80'
      image.write  img_dir + '/icon80x80.png'
      image.resize '58x58'
      image.write  img_dir + '/icon58x58.png'
      image.resize '57x57'
      image.write  img_dir + '/icon57x57.png'
      image.resize '29x29'
      image.write  img_dir + '/icon29x29.png'
      Longbow::green ('  - Created iPhone icon images for ' + target) if $verbose
    end

    if iPad
      image.resize '152x152'
      image.write  img_dir + '/icon152x152.png'
      image.resize '144x144'
      image.write  img_dir + '/icon144x144.png'
      image.resize '100x100'
      image.write  img_dir + '/icon100x100.png'
      image.resize '80x80'
      image.write  img_dir + '/icon80x80.png'
      image.resize '76x76'
      image.write  img_dir + '/icon76x76.png'
      image.resize '72x72'
      image.write  img_dir + '/icon72x72.png'
      image.resize '58x58'
      image.write  img_dir + '/icon58x58.png'
      image.resize '50x50'
      image.write  img_dir + '/icon50x50.png'
      image.resize '40x40'
      image.write  img_dir + '/icon40x40.png'
      image.resize '29x29'
      image.write  img_dir + '/icon29x29.png'
      Longbow::green ('  - Created iPad icon images for ' + target) if $verbose
    end
    return true
  end


  # Create JSON
  def self.write_json_for_icons(directory, t, obj)
    # Bad Params
    if !directory || !t
      return false
    end

    # Set Up
    target = t['name']

    # Get Device Information
    iPhone = false
    iPad = false
    if obj['devices']
      obj['devices'].each do |d|
        iPhone = true if d == 'iPhone'
        iPad = true if d == 'iPad'
      end
    end

    # Make directory
    img_dir = make_asset_directory directory, target

    # Write the JSON file
    File.open(img_dir + '/Contents.json', 'w') do |f|
      f.write('{ "images" : [ ')

      if iPhone
        f.write( '{ "size" : "29x29", "idiom" : "iphone", "filename" : "icon58x58.png", "scale" : "2x" }, { "size" : "40x40", "idiom" : "iphone", "filename" : "icon80x80.png", "scale" : "2x" }, { "size" : "60x60", "idiom" : "iphone", "filename" : "icon120x120.png", "scale" : "2x" }, { "size" : "29x29", "idiom" : "iphone", "filename" : "icon29x29.png", "scale" : "1x" }, { "size" : "57x57", "idiom" : "iphone", "filename" : "icon57x57.png", "scale" : "1x" }, { "size" : "57x57", "idiom" : "iphone", "filename" : "icon114x114.png", "scale" : "2x" }' + (iPad ? ',' : ''))
      end

      if iPad
        f.write( '{ "idiom" : "ipad", "size" : "29x29", "scale" : "1x", "filename" : "icon29x29.png" }, { "idiom" : "ipad", "size" : "29x29", "scale" : "2x", "filename" : "icon58x58.png" }, { "idiom" : "ipad", "size" : "40x40", "scale" : "1x", "filename" : "icon40x40.png" }, { "idiom" : "ipad", "size" : "40x40", "scale" : "2x", "filename" : "icon80x80.png" }, { "idiom" : "ipad", "size" : "76x76", "scale" : "1x", "filename" : "icon76x76.png" }, { "idiom" : "ipad", "size" : "76x76", "scale" : "2x", "filename" : "icon152x152.png" }, { "idiom" : "ipad", "size" : "50x50", "scale" : "1x", "filename" : "icon50x50.png" }, { "idiom" : "ipad", "size" : "50x50", "scale" : "2x", "filename" : "icon100x100.png" }, { "idiom" : "ipad", "size" : "72x72", "scale" : "1x", "filename" : "icon72x72.png" }, { "idiom" : "ipad", "size" : "72x72", "scale" : "2x", "filename" : "icon144x144.png" }')
      end

      f.write(' ], "info" : { "version" : 1, "author" : "xcode" }, "properties" : { "pre-rendered" : true } }')
    end

    # Return true
    Longbow::green ('  - Created Images.xcassets icon set for ' + target) if $verbose
    return true
  end


  # Make Directory for Images.xcassets
  def self.make_asset_directory directory, target
    asset_path = assets_file_path directory
    full_path = asset_path + '/' + target + '.appiconset/'
    FileUtils::mkdir_p full_path
    return full_path
  end


  def self.assets_file_path directory
    asset_path = ''
    Dir.glob(directory + '/**/*/').each do |d|
      searching = 'Images.xcassets/'
      asset_path = d if d.slice(d.length - searching.length, searching.length) == searching
    end

    return asset_path
  end


  # Download Image from URL
  def self.path_for_downloaded_image_from_url directory, target, url
    img_path = directory + '/resources/icons/'
    img_file_name = target + '.png'
    return (img_path + img_file_name) if File.exists? img_path+img_file_name

    FileUtils::mkdir_p img_path
    File.open(img_path + img_file_name, 'wb') do |f|
      f.write open(url).read
    end

    return img_path + img_file_name
  end


end