require 'socket'

players = Hash.new


server = TCPServer.new 18000
loop do
  Thread.start(server.accept) do |client|
    #client.puts "Hello !"
    puts "New client!"
    while client do
      data = client.recv(1000)
      data = data.delete(' ')
      recv_data = data.split(',')
      speaking_with = recv_data[0].to_i
      coords_x = recv_data[1]
      coords_y = recv_data[2]
      if speaking_with != 0 and players[speaking_with] == nil then
        players[speaking_with] = { x: 0, y: 0 }
      end

      if speaking_with != 0 then
        players[speaking_with][:x] = coords_x.to_i
        players[speaking_with][:y] = coords_y.to_i
      end

      players.each do |key, player|
        message = format('%03d%04d%04d', key, player[:x], player[:y])
        client.puts message << 0
        puts message
      end
      puts "polla"
      sleep 0.01
    end
  end
end
