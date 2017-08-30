#! /usr/bin/env ruby

require 'sinatra/base'
require 'json'
require 'active_record'
require 'thin'
require 'base64'

require './test_run'
require './mock_response'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'mockdb.sqlite3.db',
  :pool => 30,
  :timeout  => 1000
)

class MockServer < Sinatra::Base

  configure do
   set :bind, '0.0.0.0'
   set :server, 'thin'
   enable :logging
  end

  get '/hello-world' do
    response = { response: "Hello world!" }
    echo = params["echo"]
    unless echo.nil?
      response["echo"] = echo
    end
    json(response)
  end
  
  # check for required parameters
  before /\/(test|mock)/ do
    @test_name = params['test_name'] || env['HTTP_X_TEST_NAME']
    halt 400, "test_name is missing" unless @test_name
    @test_run = TestRun.find_by(name: @test_name)
  end
  
  # clear connections otherwise connection pool gets drained quickly
  after do
    ActiveRecord::Base.clear_active_connections!
  end
  
  post '/test' do
    TestRun.create do |t|
      t.name = @test_name
      t.started = Time.now
    end
  end
  
  delete '/test' do
    validate_test_run
    @test_run.destroy
  end
  
  def validate_test_run
    unless @test_run
      logger.error "=> No test running! Start first"
      halt 400, "test run not found. Did you post to /test first?"
    end
  end
    
  # reads body as a newline delimited events
  # each line is a tracking event
  post '/tracking-log-batch' do
    validate_test_run
    if request.body.size > 0
      request.body.rewind
      request.body.readlines.each do |l|
        TrackingEvent.create do |e|
          e.content = l.strip
          e.test_run = @test_run
        end
      end
    end
  end
  
  post '/mock' do
    # store mock response for a request
    validate_test_run

    path = URI.parse(params['url']).path
    unless params['file']
      logger.info "missing response body #{path}"
      halt 500, "missing response body"
    end

    MockResponse.create do |r|
      r.url = path
      r.method = params['method']
      r.parameters = params['parameters']
      r.response_mime_type = params['mime_type']
      r.response_encoding = params['encoding']
      r.response_status_code = params['status_code']
      raw_body  = params['file'][:tempfile].read
      body = params['encoding'] == 'base64' ? raw_body : raw_body.force_encoding(params['encoding'])
      r.response_body = body
      r.test_run = @test_run
    end
    logger.info "=> Created mock for path #{path}"
  end

  def handle_all_requests(request, params, method)
    r = MockResponse.find_by(url: request.path_info, method: method)
    halt 404, "mock response not found" unless r

    set_headers(r.response_mime_type)
    status r.response_status_code

    body case r.response_encoding
    when 'base64'
      Base64.decode64(r.response_body)
    else
      r.response_body
    end
  end
  
  get '/*' do
    handle_all_requests(request, params, 'GET')
  end
  
  post '/*' do
    handle_all_requests(request, params, 'POST')
  end
  
  put '/*' do
    handle_all_requests(request, params, 'PUT')
  end
  
  delete '/*' do
    handle_all_requests(request, params, 'DELETE')
  end

  not_found do
   json({ error: "Not Found" })
  end

  def json_file(name)
    set_headers("application/json")
    File.read(File.join(File.dirname(__FILE__), name))
  end

  def set_headers(mimeType)
   headers "Content-Type" => mimeType
  end

  def json(body)
   set_headers("application/json")
   JSON.generate(body)
  end

  run! if app_file == $0
end
