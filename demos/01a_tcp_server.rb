require 'socket'
require 'thread'

# If any thread throws an exception, shut everything down.
Thread.abort_on_exception = true

# 1. Construct TCPServer.new(host, port)
# 2. In main program call server.accept repeatedly.
# 3. Each time fork a thread and pass to a handle_client method.
# 4. You can now use puts and gets normally.
# 5. You can use client_socket.peeraddr to see the details of the
#    client connection.
# 6. When gets returns nil close the socket.

def handle_client_socket(client_socket)
  while true
    msg = client_socket.gets
    if msg.nil?
      client_socket.close
      return
    end
    msg.chomp!
    p client_socket.peeraddr
    puts msg
    client_socket.puts(msg.reverse)
  end
end

server = TCPServer.new('127.0.0.1', 9999)
while true
  socket = server.accept
  Thread.new { handle_client_socket(socket) }
end
