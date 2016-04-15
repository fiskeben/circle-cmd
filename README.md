# circle-cmd

A command line tool for opening your Git repo in Circle CI.

## Requirements

Ruby installed to `/usr/bin/ruby`.

This has only been tested on a Mac and will only work on Unix-like systems.
Pull requests with Windows support are welcome.

## Installation

Clone this project to somewhere on your disk and add `circle.rb` to your path.
I prefer to remove the `.rb` by linking it:

```
ln -s ../my-stuff/circle-cmd/circle.rb circle
```

Configure your organization name in Git:

```
git config --global --add circle-ci.organization acme
```

... where `acme` is your organization's name.

## Usage

Just `cd` to a Git repository and type `circle`.
