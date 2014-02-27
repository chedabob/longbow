require 'mini_magick'

module Longbow
  # Resize Icon
  def resize_icon(directory, image_name, target, iPhone, iPad)
    # Bad Params
    if !directory || !image_name || !(iPhone || iPad) || !target
      return false
    end

    image = MiniMagick::Image.open(directory + '/resources/' + image_name)
    if !image
      return false
    end

    if iPhone
      image.resize '120x120'
      image.write  directory + '/Images.xcassets/' + target + '.appiconset/icon120x120.png'
      image.resize '114x114'
      image.write  directory + '/Images.xcassets/' + target + '.appiconset/icon114x114.png'
      image.resize '80x80'
      image.write  directory + '/Images.xcassets/' + target + '.appiconset/icon80x80.png'
      image.resize '58x58'
      image.write  directory + '/Images.xcassets/' + target + '.appiconset/icon58x58.png'
      image.resize '57x57'
      image.write  directory + '/Images.xcassets/' + target + '.appiconset/icon57x57.png'
      image.resize '29x29'
      image.write  directory + '/Images.xcassets/' + target + '.appiconset/icon29x29.png'
      puts('  Created iPhone images for ' + target) if $VERBOSE
    end

    if iPad
      image.resize '152x152'
      image.write  directory + '/Images.xcassets/' + target + '.appiconset/icon152x152.png'
      image.resize '144x144'
      image.write  directory + '/Images.xcassets/' + target + '.appiconset/icon144x144.png'
      image.resize '100x100'
      image.write  directory + '/Images.xcassets/' + target + '.appiconset/icon100x100.png'
      image.resize '80x80'
      image.write  directory + '/Images.xcassets/' + target + '.appiconset/icon80x80.png'
      image.resize '76x76'
      image.write  directory + '/Images.xcassets/' + target + '.appiconset/icon76x76.png'
      image.resize '72x72'
      image.write  directory + '/Images.xcassets/' + target + '.appiconset/icon72x72.png'
      image.resize '58x58'
      image.write  directory + '/Images.xcassets/' + target + '.appiconset/icon58x58.png'
      image.resize '50x50'
      image.write  directory + '/Images.xcassets/' + target + '.appiconset/icon50x50.png'
      image.resize '40x40'
      image.write  directory + '/Images.xcassets/' + target + '.appiconset/icon40x40.png'
      image.resize '29x29'
      image.write  directory + '/Images.xcassets/' + target + '.appiconset/icon29x29.png'
      puts('  Created iPad images for ' + target) if $VERBOSE
    end

    return true
  end

  # Create JSON
  def write_json_for_icons(directory, target, iPhone, iPad)
    # Bad Params
    if !directory || !target || !(iPhone || iPad)
      return false
    end

    # Write the JSON file
    File.open(directory + '/Images.xcassets/' + target + '.appiconset/Contents.json', 'w') do |f|
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
    return true
  end
end