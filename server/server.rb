require 'socket'

player0 = {id: 0, x: 100, y: 100}
player1 = {id: 1, x: 600, y: 100}

server = TCPServer.new 18000
loop do
  Thread.start(server.accept) do |client|
    client.puts "Hello !"
    puts "New client!"
    while client do
      data = client.recv(1000)
      puts data
      puts "Mola!"
      client.puts "k pasa bro"
    end
  end
end
