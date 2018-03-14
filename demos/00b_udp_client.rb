require 'socket'

# #bind to whatever port is convenient using port 0
# #send(msg, 0 flags, host, port)

# 1. Construct and bind to any port.
# 2. Send message.
# 3. Await response.

socket = UDPSocket.new
socket.bind('127.0.0.1', 0)
socket.send('hello there!', 0, '127.0.0.1', 9999)
response = socket.recvfrom(255)
p response
