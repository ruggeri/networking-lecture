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

    # If they use curie in the path, then stop processing the request
    # and immediately yell at them.
    if /curie/ =~ req.path
      res = Rack::Response.new
      res.headers['Content-Type'] = 'text/html'
      res.body = ['<p>CURIE REQUESTS NOT ALLOWED</p>']

      return res.finish
    end

    # Otherwise move on to the next middleware.
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

    # This looks for the cookie saved under session. I want it to be a
    # serialized hash like Rails does. After parsing the cookie, I
    # will save this under env['SESSION'] so the user can interact
    # with a nice hash rather than just a serialized string.
    cookie_value = req.cookies['session']
    if cookie_value.nil?
      env['SESSION'] = {}
    else
      env['SESSION'] = JSON.parse(cookie_value)
    end

    # Call the next middleware to resume processing the request. Now
    # SESSION is a key in the env hash.
    status, headers, body = next_middleware.call(env)

    # Rebuild a response object, so that we can be sure to set the
    # cookie again for next time. Here I'm doing some
    # "postprocessing."
    response = Rack::Response.new(body, status, headers)
    response.set_cookie('session', JSON.generate(env['SESSION']))

    return response.finish
  end
end

app = Proc.new do |env|
  puts "Running application!"

  # In my application code, I can use the SESSION key. This code
  # doesn't need to know how to parse serialized session cookies.
  session = env['SESSION']
  if session.has_key?('count')
    # My code can also modify the session hash.
    session['count'] += 1
  else
    session['count'] = 0
  end

  res = Rack::Response.new
  res.headers['Content-Type'] = 'text/html'
  res.body = ["<p>You have been here #{session['count']} times before!</p>"]

  res.finish
end

# This is a simple way to ask Rack to do a series of operations.
middleware_stack = Rack::Builder.new do
  self.use CurieBlockerMiddleware
  self.use CookieParser
  self.run app
end.to_app

Rack::Handler::WEBrick.run(
  middleware_stack,
  "Port": 9999,
)
