require 'net/http'
require 'openssl'
require 'uri'
require 'json'

CIRCLE_CI_URI = "https://circleci.com/api/v1/"

class CircleClient

  def initialize(token)
    @token = token
  end

  def me(options={})
    url = "me?circle-token=#{@token}"
    get(url)
  end

  def list_builds(username, project, number, options={})
    url = "project/#{username}/#{project}?circle-token=#{@token}&limit=#{number}"
    get(url)
  end

  def retry_build(username, project, build_num, options={})
    url = "#{username}/#{project}/#{build_num}/retry?circle-token=#{@token}"
    post(url)
  end

  def cancel_build(username, project, build_num, options={})
    url = "#{username}/#{project}/#{build_num}/cancel?circle-token=#{@token}"
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
    do_request(http, reuest)
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
      raise StandardError.new("Error talking to CircleCI API")
    end
  end
end
