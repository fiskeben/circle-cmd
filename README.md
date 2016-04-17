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

circle-cmd will ask for a *CircleCI token* and your username/organization
the first time you run it.

Note on username/organization: If you're using CircleCI with an organization
you need to type it's name at the prompt. Otherwise you should be good to go
with the default value (which should be your username).


## Usage

Usage: `circle [command]`

Commands:
open            Opens the current project in your browser
recent [n]      Show info about the recent [n] builds
retry [id]      Retry a build
cancel [id]     Cancel the build with ID or the latest
me              Displays info about the registered user

Or type `circle help` for help.
