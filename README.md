# Longbow

**Problem**

One codebase. Multiple App Store submissions with different icons, info.plist keys, etc.

**Solution**

```
longbow install
longbow create -n AppTargetName
```

**About**

Longbow duplicates the main target in your `.xcworkspace` or `.xcodeproj` file, then reads from a JSON file to fill out the rest of your target. It looks for certain keys and creates such things like taking an icon image and resizing it for the various icons you'll need, and adding keys to the info.plist file for that target. The goal was to be practically autonomous in creating new targets and apps.

## Installation

Add this line to your application's Gemfile:

    gem 'longbow'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install longbow

## Set Up

Run `longbow install` in the directory where your `.xcworkspace` or `.xcodeproj` file lives. This will create two files, `.longbow.{json,screens}`, where they will be used to build out from here. You are almost ready to start creating new targets

## Formatting .longbow.json



## Formatting .longbow.screens

## Create

## Update

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
