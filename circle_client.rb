require 'net/http'
require 'openssl'
require 'uri'
require 'json'
require 'time'

CIRCLE_CI_URI = "https://circleci.com/api/v1.1/"

class CircleClient

  def initialize(token)
    @token = token
  end

  def me(options={})
    url = "me?circle-token=#{@token}"
    get(url)
  end

  def list_builds(username, project, number, options={})
    url = "project/github/#{username}/#{project}?circle-token=#{@token}&limit=#{number}"
    get(url).collect do |b|
      build_time_millis = 0

      if b.build_time_millis.nil?
        unless b.start_time.nil?
          start_time = Time.parse(b.start_time).utc
          now = Time.now.utc
          build_time_millis = (now.to_time.to_i - start_time.to_time.to_i) * 1000
        end
      else
        build_time_millis = b.build_time_millis.to_i
      end

      if build_time_millis > 0
        seconds = build_time_millis / 1000
        s = seconds % 60
        seconds /= 60
        m = seconds % 60
        seconds /= 60
        h = seconds % 60

        s = "0#{s}" if s < 10
        m = "0#{m}" if h > 0 && m < 10

        if h > 0
          b.build_time_human_readable = "#{h}:#{m}:#{s}"
        elsif h == 0 && m > 0
          b.build_time_human_readable = "#{m}:#{s}"
        else
          b.build_time_human_readable = "#{s} sec"
        end
      else
        b.build_time_human_readable = "Not started"
      end
      b
    end
  end

  def retry_build(username, project, build_num, options={})
    url = "project/github/#{username}/#{project}/#{build_num}/retry?circle-token=#{@token}"
    post(url)
  end

  def cancel_build(username, project, build_num, options={})
    url = "/project/github/#{username}/#{project}/#{build_num}/cancel?circle-token=#{@token}"
    post(url)
  end

  private

  def get(path, options={})
    uri = create_uri(path)
    http = create_http(uri)
    request = create_get(uri)
    do_request(http, request)
  end

  def post(path, options={})
    uri = create_uri(path)
    http = create_http(uri)
    request = create_post(uri)
    do_request(http, request)
  end

  def create_uri(path)
    URI.parse("#{CIRCLE_CI_URI}#{path}")
  end

  def create_http(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http
  end

  def create_get(uri)
    request = Net::HTTP::Get.new(uri.request_uri)
    request["Accept"] = "application/json"
    request
  end

  def create_post(uri)
    p uri.request_uri
    request = Net::HTTP::Post.new(uri.request_uri)
  end

  def do_request(http, request)
    response = http.request(request)

    if response.kind_of? Net::HTTPSuccess
      json = JSON.parse(response.body)
      if json.is_a? Array
        return json.collect do |item|
          OpenStruct.new(item)
        end
      else
        return OpenStruct.new(json)
      end
    else
      p response, request
      raise StandardError.new("Error talking to CircleCI API")
    end
  end
end
