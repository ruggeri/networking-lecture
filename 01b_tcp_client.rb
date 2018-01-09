require 'socket'
require 'thread'

# If any thread throws an exception, shut everything down.
Thread.abort_on_exception = true

# To start a connection, a client will send a TCP packet called a SYN
# packet. It is just an IP datagram empty accept for the target port
# number.
#
# What happens on opening a connection?
#
# First the client sends a message: 'I want to connect! I am port XYZ,
# I will number my messages starting at 123'. This is called a SYN.
#
# Next the server replies: 'I connect you! I will number your messages
# starting at 456.' The server does not need to give any new port for
# this connection.
#
# The client replies: 'Wonderful! I acknowledge receipt of your first
# message, 456.'
#
# Going forward, a message is only delivered by a socket if all prior
# messages (by sequence number) have been delivered. For each packet
# the OS receives, it will send an ACK packet. If the sender's OS
# doesn't receive that ACK packet after a short time, it will resend
# the packet.
#
# There is no harm in resending packets. If the recipient *has*
# received a packet, and gets a duplicate, it can ignore this, because
# it looks at the sequence number of the resent packet, and says:
# 'I've already delivered this packet number.'
#
# Note: sent packets must be buffered by the sender's OS until an ACK
# is received, since they may need to be resent. Also: a received
# packet may not be deliverable because some earlier messages may not
# have been received. In that case, a received packet may be buffered
# by the receiver's OS until it can be delivered.
socket = TCPSocket.new('127.0.0.1', 9999)
puts "Me: #{socket.addr}"
puts "Them: #{socket.peeraddr}"

t1 = Thread.new do
  while true
    msg = socket.gets.chomp
    puts msg
  end
end

t2 = Thread.new do
  while true
    msg = gets.chomp
    socket.puts(msg)
  end
end

# Neither thread should ever join.
t1.join
t2.join
