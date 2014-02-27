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

## Table of Contents

* [Installation](#installation)
* [Set Up](#set-up)
* [Formatting .longbow.json](#formatting-longbow-json)
* [Formatting .longbow.screens](#formatting-longbow-screens)
* [Create a Target](#create-a-target)
* [Update a Target](#update-a-target)
* [Global Options](#global-options)
* [Contributing](#contributing)

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

Here's a basic gist of how to format your `.longbow.json` file:

```
{
    "device" : "iPad" or "iPhone" or "universal"
    "orientations" : "portrait" or "landscape" or "universal"
    "targets" : {
        "NameOfTarget1" : {
            "icon_url" : "https://someurl.com/img.jpg"
            "info_plist" : {
                "key1" : "value1"
                "key2" : "value2"
            }
        }
        "NameOfTarget2" : {
            "icon_url" : "https://someurl.com/img.jpg"
            "info_plist" : {
                 "key1" : "value1"
                 "key2" : "value2"
                 }
            }
        }
    }
}
```

In the top-level of the JSON file, we have 3 key/value pairs:

* `device`
* `orientations`
* `targets`

The `targets` section contains nested key/value pairs for each specific target. Each target can contain the following keys:

* `icon_url`
* `info_plist`

The `icon_url` key corresponds to the icon image. It will be downloaded from the web and stored in your project under a new folder called `Resources/YourTarget/icon1024x1024.png`, where it will then be resized depending on your device setting and added to the Images.xcassets file for that target. The `info_plist` key corresponds to another set of key/value pairs that will be added or updated in the info.plist file specifically for this target.

## Formatting .longbow.screens

Longbow also boasts the ability to take screenshots of your app in the simulator by following a basic task timeline. There are 3 options that represent actions.

* TAP *screen points*
* WAIT *seconds*
* C

TAP simulates tapping a point on screen, WAIT will pause for a duration and C captures a screenshot. Here's how this looks.

```
TAP p(33,120) l(33, 670)
WAIT 0.5
C
TAP p(342,120) l(345, 670)
WAIT 1.3
C
```

The screenshot function just traverses this file in a linear order, top to bottom, and takes screenshots whenever C is read in on its own line. It error-handles commands and points that it cannot interpret.

## Create a Target

Now that you're set up - it's time to add a target. Make sure that you have updated your `.longbow.json` file with the correct information for your target, and then run the following command inside the project directory.

`longbow create -n NameOfTarget`

What this does is goes to your `.longbow.json` file and looks for json{"targets"}{"NameOfTarget"} and tries to create a new Target in your app, and handles the various icons/info_plist additions to make specifically for this target.

**Other Options**

* `-d, --directory` - if not in the current directory, specify a new path
* `-s, --screenshots` - if you want to take screenshots

`longbow create -n NameOfTarget -d ~/Path/To/App -s`

## Update a Target

Updating a target is very similar to creating one. Instead of the command `create` we will be using `update`.

`longbow update -n NameOfTarget`

This will update that specific target. If you leave the -n option off, it will update *ALL* targets in the `.longbow.json` file.

**Other Options**

* `-d, --directory` - if not in the current directory, specify a new path
* `-s, --screenshots` - if you want to take screenshots

## Global Options

`--verbose` will log a TON of information about what's happening to the console.

`--help` will fill you in on what you need to do for an action.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
