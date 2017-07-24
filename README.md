# circle-cmd

A command line tool for getting status about your project's build jobs in Circle CI.
Inspired by [hub](https://github.com/github/hub).

**Note:** This tool uses the 1.0 Circle CI API. For 2.0 support, take a look at [the official command line tool](https://circleci.com/docs/2.0/local-jobs/).

## Requirements

Ruby installed to `/usr/bin/ruby`.

This has only been tested on a Mac and will only work on Unix-like systems.
Pull requests with Windows support are welcome.

## Installation

### Install with Homebrew

Add my tap:

`$ brew tap fiskeben/tap`

and install:

`$ brew install circle-cmd`

### Manual installation

Clone or download this project to somewhere on your disk and add `circle.rb` to your path.
I prefer to remove the `.rb` by linking it like this:

```
$ ln -s ../my-stuff/circle-cmd/circle.rb circle
```

`circle-cmd` will ask for a **CircleCI token** and your username/organization
the first time you run it.
Create an API token from [your CircleCI account page](https://circleci.com/account/api).

Note on username/organization: If you're using CircleCI with an organization
you need to type its name at the prompt. Otherwise you should be good to go
with the default value (which should be your username).


## Usage

Running the `circle` command without arguments will open the project in your browser.

You can also use these commands:

```
Usage: `circle [command]`

Commands:
open            Opens the current project in your browser
status          Show info about the latest build
recent [n]      Show info about the recent [n] builds
retry [id]      Retry a build
cancel [id]     Cancel the build with ID or the latest
me              Displays info about the registered user
```

Or type `circle help` for help.

## TODO

Planned features:

- [ ] Trigger a new build
- [ ] Clear build cache
- [ ] Support per-project username/organization

Other [API endpoints](https://circleci.com/docs/api/) aren't planned as such unless there is demand.

PRs are welcome.
