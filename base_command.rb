require_relative './circle_client'
require_relative './tabulator'

class BaseCommand

  def initialize()
    @token = (`git config --get circle-cmd.token`).strip
    @username = (`git config --get circle-cmd.username`).strip
    @client = CircleClient.new(@token)
  end

  def show_my_details()
    details = @client.me

    puts <<-ME
Name: #{details.name}
E-mail: #{details.selected_email}
ME
    puts "Days left in trial: #{details.days_left_in_trial}" if details.days_left_in_trial.to_i >= 0
  end

  def open_project
    url = "https://circleci.com/gh/#{@username}/#{repo_name}/tree/#{branch_name}"
    exec("open '#{url}'")
  end

  def list_builds(number_of_builds_to_show)
    number_of_builds_to_show = 5 if number_of_builds_to_show.nil?
    builds = @client.list_builds(@username, repo_name, number_of_builds_to_show)

    puts "\n#{number_of_builds_to_show} recent builds:\n\n"
    tabulator = Tabulator.new(builds)
      .with_headers(['Build num', 'Subject', 'By', 'Status'])
      .with_column_names([:build_num, :subject, :committer_name, :status])

    puts tabulator
    puts ""
  end

  def retry_build(build_num=nil)
    build_num = latest_build_num if build_num.nil?

    retried_build = @client.retry_build(@username, repo_name, build_num)

    puts "Retrying '#{retried_build.subject}'"
  end

  def cancel_build(build_num=nil)
    build_num = latest_build_num if build_num.nil?

    cancelled_build = @client.cancel_build(@username, repo_name, build_num)

    puts "Cancelled build number #{build_num} (#{cancelled_build.subject})"
  end

  def is_setup?
    @token != '' && @username != ''
  end

  def my_details
    circle_client = CircleClient.new(@token)
    circle_client.me
  end

  def setup
    puts "Your system is not set up yet."
    print "What is your CircleCI token? > "

    @token = gets

    me = my_details

    print "What is your organization [#{me.login}] > "

    @username = gets

    @username = me.login if @username.strip == ""

    `git config --global --add circle-cmd.token #{@token}`
    `git config --global --add circle-cmd.username #{@username}`

    puts 'Setup complete.'
  end

  private

  def repo_name
    repo_path = git_command("git rev-parse --show-toplevel")
    repo_path.split('/').last.strip
  end

  def branch_name
    git_command("git rev-parse --abbrev-ref HEAD")
  end

  def git_command(command)
    result = (`#{command} 2>/dev/null`).strip
    if $? != 0
      puts "This doesn't seem to be a Git repo?"
      exit($?.exitstatus)
    end
    result
  end

  def latest_build_num
    builds = @client.list_builds(@username, repo_name, 1)
    build_num = builds.first.build_num
  end

end
