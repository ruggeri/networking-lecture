require 'webrick'

# 1. WEBrick::HTTPServer.new('Port': port num). #start
# 2. #mount_proc(path) { |req, res| }
# 3. Response#status=, Response#[]=(header, value)
# 4. Response#body=
# 5. WEBrick::Cookie.new(name, value). Has #value= method takes string.
# 6. req.cookies. Could start out empty.
# 7. You need to always add to response.

# 1. Simple static response.
# 2. Cookie response.

server = WEBrick::HTTPServer.new('Port': 9999)

server.mount_proc('/hello') do |req, res|
  res.status = 200
  res['Content-Type'] = 'text/html'
  res.body = 'You are cool'
end

server.mount_proc('/counter') do |req, res|
  if req.cookies.empty?
    c = WEBrick::Cookie.new('int_value', 0.to_s)
  else
    c = req.cookies[0]
    value = Integer(c.value) + 1
    c.value = value.to_s
  end
  res.status = 200
  res['Content-Type'] = 'text/html'
  res.cookies << c
  res.body = "Count is #{c.value}"
end

server.start
