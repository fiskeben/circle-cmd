#!/usr/bin/ruby

require_relative './base_command'

command = BaseCommand.new
unless command.is_setup?
  command.setup
  exit(0)
end

def extra_argument
  return ARGV[1] if ARGV.length > 1
end

def print_help(helping=true)
  puts <<-HELP

Usage: circle [command]

Commands:
open            Opens the current project in your browser
status          Show info about the latest build
recent [n]      Show info about the recent [n] builds
commit          Get the SHA of the latest successful build
retry [id]      Retry a build
cancel [id]     Cancel the build with ID or the latest
me              Displays info about the registered user

HELP
end

case ARGV.first
when 'me'
  command.show_my_details
when 'open'
  command.open_project
when 'status'
  command.current_status
when 'recent'
  command.list_builds(extra_argument)
when 'commit'
  command.latest_successful_commit
when 'retry'
  command.retry_build(extra_argument)
when 'cancel'
  command.cancel_build(extra_argument)
when 'help'
  print_help(false)
else
  unless ARGV.empty?
    puts "\nUnknown command '#{ARGV.join(' ')}'"
    print_help
  else
    command.open_project
  end
end
