require 'socket'

# Start listening for TCP connections.
server = TCPServer.new('127.0.0.1', 9999)

# 1. Just read all client lines until empty line is encountered.
# 2. Then just print out response.
# 3. Response line, content type header, blank line, content.

while true
  client_socket = server.accept
  puts "Connected new client: #{client_socket.peeraddr}"

  # Code goes here.
  while client_socket.gets.chomp != ''
    puts 'ignoring'
  end

  client_socket.puts 'HTTP/1.1 200 OK'
  client_socket.puts 'Content-Type: text/html'
  client_socket.puts ''
  client_socket.puts '<p>This is some great text</p>'
  client_socket.close
end
