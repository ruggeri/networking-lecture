require 'socket'
require 'thread'

# If any thread throws an exception, shut everything down.
Thread.abort_on_exception = true

# nc 127.0.0.1 9999

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

accepter_thread = Thread.new do
  while true
    # socket.accept says: wait until the operating has connected a
    # client.
    #
    # Even though we create a new socket for each client that
    # connects, that does not mean we need a new port for every
    # client. There is no confusion if many clients talk to the same
    # port 9999; the OS knows the port number of the client, and
    # therefore can deliver the TCP datagram to the appropriate
    # socket. A socket is an OS level concept. You can have multiple
    # sockets listening on a single port.
    client_socket = server.accept
    puts "Connected new client: #{client_socket.peeraddr}"

    # Forks a new thread to handle this connection. This lets the
    # server handle many simultaneous connections.
    Thread.new { handle_client(client_socket) }
  end
end

# Work of accepter thread is never done!
accepter_thread.join
