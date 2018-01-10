require 'socket'
require 'thread'

# If any thread throws an exception, shut everything down.
Thread.abort_on_exception = true

# The OS will allocate a port for this TCP socket to receive
# replies. It will send out a SYN packet to start the handshake that
# sets up the TCP connection.
socket = TCPSocket.new('127.0.0.1', 9999)
puts "Me: #{socket.addr}"
puts "Them: #{socket.peeraddr}"

t1 = Thread.new do
  while true
    # We print each message sent back to us.
    msg = socket.gets.chomp
    puts msg
  end
end

t2 = Thread.new do
  while true
    # We send each line of user input to the other machine.
    msg = gets.chomp
    socket.puts(msg)
  end
end

# Neither thread should ever join.
t1.join
t2.join
