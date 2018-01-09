require 'webrick'

server = WEBrick::HTTPServer.new("Port": 9999)

server.mount_proc('/markov') do |req, res|
  # here is what we do for each request and response.

  res.status = 200
  res['Content-Type'] = 'text/html'
  res.body = "<p>Markov's the best!</p>"
end

server.mount_proc('/curie') do |req, res|
  # here is what we do for each request and response.

  res.status = 200
  res['Content-Type'] = 'text/html'
  res.body = "<p>Curie's the best!</p>"
end

server.mount_proc('/counter') do |req, res|
  p req.cookies
  if req.cookies.empty?
    count = 0
    c = WEBrick::Cookie.new('count', count.to_s)
  else
    c = req.cookies[0]
    count = Integer(c.value) + 1
    c.value = count.to_s
  end

  res.status = 200
  res.cookies << c
  res['Content-Type'] = 'text/html'
  res.body = "<p>Your count is #{count}</p>"
end

server.start
