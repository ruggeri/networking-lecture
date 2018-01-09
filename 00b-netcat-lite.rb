require 'socket'
require 'thread'

# If any thread throws an exception, shut everything down.
Thread.abort_on_exception = true

raise 'nc [host] [port]' unless ARGV.length == 2
target_host = ARGV.shift
target_port = ARGV.shift

socket = UDPSocket.new

# You can give me wahtever port you like.
socket.bind('127.0.0.1', 0)
puts "Address: #{socket.addr}"

t1 = Thread.new do
  while true
    msg = socket.recvfrom(255)
    p msg
  end
end

t2 = Thread.new do
  while true
    input = gets.chomp
    socket.send(input, 0, target_host, target_port)
  end
end

# t1 will never join because it will never be done.
t1.join
