require 'rack'

app = Proc.new do |env|
  # Rack gives us an env hash. The env includes the request
  # information. But I'm just going to ignore it.

  res = Rack::Response.new
  res.headers['Content-Type'] = 'text/html'
  res.body = ['<p>this is my text</p>']

  # res.finish just converts the response object to [status, headers,
  # body].
  p res.finish
  res.finish
end

# Tells Rack to run WEBrick web server on port 9999, and to have
# WEBrick hand off requests to our application code.
Rack::Handler::WEBrick.run(
  app,
  "Port": 9999,
)
