require 'socket'

players = [{x: 100, y: 100}, {x: 600, y: 100}]


server = TCPServer.new 18000
loop do
  Thread.start(server.accept) do |client|
    #client.puts "Hello !"
    puts "New client!"
    while client do
      data = client.recv(1000)
      data = data.delete(' ')
      recv_data = data.split(',')
      speaking_with = recv_data[0]
      coords_x = recv_data[1]
      coords_y = recv_data[2]

      if data.length > 6 then
        players[speaking_with.to_i][:x] = coords_x.to_i
        players[speaking_with.to_i][:y] = coords_y.to_i
      end

      players.each_with_index do |player, i|
        message = format('%03d%04d%04d', i, player[:x], player[:y])
        client.puts message << 0
      end

      sleep 0.01
    end
  end
end
