require 'json'
require 'rack'

# 1. Rack::Builder.new {}, give a list of use calls with middlewares.
# 1b. Last must be a #run command
# 2. For a middleware class, you get passed middleware; and you implement call(env)
# 3. You just call the middleware to continue.
# 4. call #to_app at end to construct the stack.
# 5. You can have classes where you save the next middlerware.
# 6a. Request.new(env). req#path
# 6. Request#cookies[cookie_name] => value string.
# 7. can set any key on ENV hash.
# 8a. #finish => [status, headers, body]
# 8. Rack::Response.new(body, status, headers)
# 9. Response#set_cookie(key, value)

# 1. Top middleware first. Simple static response.
# 2. Next middleware: curie blocker. Test Request#path.
# 3. Add cookie parsing middleware

class CurieBlocker
  def initialize(next_middleware)
    @next_middleware = next_middleware
  end

  def call(env)
    req = Rack::Request.new(env)
    if req.path =~ /curie/
      res = Rack::Response.new
      res.status = 403
      return res.finish
    end
    return @next_middleware.call(env)
  end
end

class CookieParser
  def initialize(next_middleware)
    @next_middleware = next_middleware
  end

  def call(env)
    req = Rack::Request.new(env)
    if req.cookies['session'].nil?
      env['SESSION'] = {}
    else
      env['SESSION'] = JSON.parse(req.cookies['session'])
    end

    status, headers, body = @next_middleware.call(env)
    response = Rack::Response.new(body, status, headers)
    response.set_cookie('session', env['SESSION'].to_json)

    response.finish
  end
end

app = Proc.new do |env|
  if env['SESSION']['counter']
    counter = Integer(env['SESSION']['counter']) + 1
  else
    counter = 0
  end

  env['SESSION']['counter'] = counter

  res = Rack::Response.new
  res.status = 200
  res.headers['Content-Type'] = 'text/html'
  res.body = ["<p>Some text here: #{counter}</p>"]

  res.finish
end

middleware_stack = Rack::Builder.new do
  use CurieBlocker
  use CookieParser
  run app
end.to_app

Rack::Handler::WEBrick.run(
  middleware_stack,
  "Port": 9999,
)
