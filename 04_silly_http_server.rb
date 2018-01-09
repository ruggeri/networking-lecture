require 'socket'

# Creates a server object. This asks the operating system to listen
# for TCP connections on port 9999.
server = TCPServer.new('127.0.0.1', 9999)

def handle_client(client_socket)
  while true
    client_message = client_socket.gets
    puts "#{client_socket.peeraddr}: #{client_message}"
    client_socket.puts(client_message)
  end
end

while true
  client_socket = server.accept
  puts "Connected new client: #{client_socket.peeraddr}"

  while (msg = client_socket.gets.chomp) != ""
    puts "IGNORING: #{msg}"
  end

  client_socket.puts "HTTP/1.1 200 OK"
  client_socket.puts "Content-Type: text/html"
  client_socket.puts ""
  client_socket.puts "<p>This is some quality text right here!</p>"
  client_socket.close
end
