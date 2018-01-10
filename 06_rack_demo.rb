require 'rack'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new

  res.headers['Content-Type'] = 'text/html'
  res.body = ['<p>this is my text</p>']
  p res.finish
  res.finish
end

Rack::Handler::WEBrick.run(
  app,
  "Port": 9999,
)
