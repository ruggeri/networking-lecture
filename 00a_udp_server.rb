require 'socket'

# nc -u 127.0.0.1 9999

# Creates a socket object. The socket starts out unconfigured and is
# not yet ready for use.
socket = UDPSocket.new

# This says to the operating system: please listen for any packets
# sent to IP address 127.0.0.1 for socket 9999. If socket 9999 is
# already in use, the operating system will give an error which says:
# "Someone is already using that socket; you can't use it."
socket.bind('127.0.0.1', 9999)

while true
  # Read up to 255 bytes from the socket. Waits for 255 bytes or a
  # newline.
  msg = socket.recvfrom(255)
  p msg

  # Who is sending us this datagram? Could be from anyone! UDP is
  # *connectionless*.
  sender_host = msg[1][2]
  sender_port = msg[1][1]

  # The 0 is some options flag. It may be ignored.
  socket.send("I acknowledge you.\n", 0, sender_host, sender_port)
end
