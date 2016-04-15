#!/usr/bin/ruby

repo_path = `git rev-parse --show-toplevel`

if $? == 0
  organization = (`git config --get circle-ci.organization`).strip
  if organization == ''
    puts "Please set your organization's name like (like this: git config --global --add circle-ci.organization acme)"
    exit(1)
  end
  repo_name = repo_path.split('/').last.strip
  branch_name = (`git rev-parse --abbrev-ref HEAD`).strip
  url = "https://circleci.com/gh/#{organization}/#{repo_name}/tree/#{branch_name}"
  exec("open '#{url}'")
end
