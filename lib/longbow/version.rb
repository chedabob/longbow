$:.push File.expand_path('../', __FILE__)
require 'colors'

module Longbow
  VERSION = '0.1.0'

  def self.check_for_newer_version
    if `gem outdated -r`.include? 'longbow'
      puts
      Longbow::purple "  A newer version of longbow is available. Run 'gem update longbow'."
      puts
    end
  end
end
