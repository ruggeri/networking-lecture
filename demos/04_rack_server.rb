require 'rack'

# 1. Rack::Handler::WEBrick#run(app, 'Port': port)
# 2. app can be a proc which takes an environment object
# 3. You create a Rack::Response.new()
# 4. you can set res.status=, res.headers[]=
# 5. you can set res.body = ['array', 'of', 'text']
# 6. you return res.finish

# Build simple static response

app = Proc.new do |env|
  res = Rack::Response.new

  res.status = 200
  res.headers['Content-Type'] = 'text/html'
  res.body = ['<p>hello there</p>']

  res.finish
end

Rack::Handler::WEBrick.run(app, 'Port': 9999)
