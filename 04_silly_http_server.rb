require 'socket'

# Start listening for TCP connections.
server = TCPServer.new('127.0.0.1', 9999)

while true
  client_socket = server.accept
  puts "Connected new client: #{client_socket.peeraddr}"

  # Just ignore whatever HTTP request is sent.
  while (msg = client_socket.gets.chomp) != ""
    puts "IGNORING: #{msg}"
  end

  # Print out the same thing every time.
  client_socket.puts "HTTP/1.1 200 OK"
  client_socket.puts "Content-Type: text/html"
  client_socket.puts ""
  client_socket.puts "<p>This is some quality text right here!</p>"
  client_socket.close
end
