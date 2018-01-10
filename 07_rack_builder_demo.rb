require 'json'
require 'rack'

class CurieBlockerMiddleware
  attr_reader :next_middleware

  def initialize(next_middleware)
    @next_middleware = next_middleware
  end

  def call(env)
    puts "Running CurieBlocker"
    req = Rack::Request.new(env)

    if /curie/ =~ req.path
      res = Rack::Response.new
      res.headers['Content-Type'] = 'text/html'
      res.body = ['<p>CURIE REQUESTS NOT ALLOWED</p>']

      return res.finish
    end

    return next_middleware.call(env)
  end
end

class CookieParser
  attr_reader :next_middleware

  def initialize(next_middleware)
    @next_middleware = next_middleware
  end

  def call(env)
    puts "Running CookieParser"
    req = Rack::Request.new(env)

    cookie_value = req.cookies['session']
    if cookie_value.nil?
      env['SESSION'] = {}
    else
      env['SESSION'] = JSON.parse(cookie_value)
    end

    status, headers, body = next_middleware.call(env)
    response = Rack::Response.new(body, status, headers)

    response.set_cookie('session', JSON.generate(env['SESSION']))

    return response.finish
  end
end

app = Proc.new do |env|
  puts "Running application!"

  req = Rack::Request.new(env)
  res = Rack::Response.new

  session = env['SESSION']
  if session.has_key?('count')
    session['count'] += 1
  else
    session['count'] = 0
  end

  res.headers['Content-Type'] = 'text/html'
  res.body = ["<p>You have been here #{session['count']} times before!</p>"]

  res.finish
end

middleware_stack = Rack::Builder.new do
  #self.use CurieBlockerMiddleware
  self.use CookieParser
  self.run app
end.to_app

Rack::Handler::WEBrick.run(
  middleware_stack,
  "Port": 9999,
)
