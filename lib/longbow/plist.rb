$:.push File.expand_path('../', __FILE__)
require 'mini_magick'
require 'colors'
require 'xcodeproj'
require 'open-uri'

module Longbow

  # Create Plist from Original Plist Content
  def self.create_plist_from_old_plist old_plist, info_hash, global_hash
    return '' unless old_plist && info_hash && global_hash
    plist_text = old_plist
    [info_hash,global_hash].each do |hash|
      hash.each_key do |k|
        value = hash[k]
        matches = plist_text.match /<key>#{k}<\/key>\s*<(.*?)>.*<\/(.*?)>/
        if matches
          plist_text = plist_text.sub(matches[0], "<key>" + k + "</key>\n" + recursive_plist_value_for_value(value))
        else
          plist_text = plist_text.sub(/<\/dict>\s*<\/plist>/, "<key>" + k + "</key>\n" + recursive_plist_value_for_value(value) + "</dict></plist>")
        end
      end
    end

    return plist_text
  end

  # Recursively create Plist Values for a given object
  def self.recursive_plist_value_for_value value
    return '' unless value

    # Check Number
    if value.kind_of?(Numeric)
      return '<real>' + value.to_s + '</real>'
    end

    # Check Boolean
    if !!value == value
      if value == true
        return '<true />'
      else
        return '<false />'
      end
    end

    # Check Array
    if value.kind_of?(Array)
      total_values = '<array>'
      value.each do |v|
        total_values += recursive_plist_value_for_value(v)
      end
      return total_values + '</array>'
    end

    # Check Hash
    if value.kind_of?(Hash)
      total_values = '<dict>'
      value.each_key do |key|
        total_values += '<key>' + key + '</key>'
        total_values += recursive_plist_value_for_value value[key]
      end
      return total_values + '</dict>'
    end

    return '<string>' + value.to_s + '</string>'
  end

end