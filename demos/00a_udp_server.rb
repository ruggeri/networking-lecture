require 'socket'

# UDPSocket.new
# #bind(ip, port)
# #recvfrom(num_bytes_max) => [msg, [_, senderport, senderhost, senderip]]
# #send(message, 0 flags, ip, port)

# 1. Construct and bind socket.
# 2. Receive message
# 3. Reverse and send back.

# Wireshark interface: lo0
# wireshark filter: udp.port == 9999.
# Show payload, source and destination ports.

s = UDPSocket.new
s.bind('127.0.0.1', 9999)
msg = s.recvfrom(255)
p msg

s.send(msg[0].reverse, 0, msg[1][2], msg[1][1])
