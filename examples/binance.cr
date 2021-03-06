require "json"
require "http"

require "../src/disruptor"

size = 2048
channel = Channel(String).new
disruptor = Disruptor::Queue(String).new(size, Disruptor::WaitWithYield.new)

spawn do
  socket = HTTP::WebSocket.new("wss://stream.binance.com:9443/ws/btcusdt@trade")
  socket.on_message do |message|
    disruptor.push message
  end
  socket.run
end

spawn do
  socket = HTTP::WebSocket.new("wss://stream.binance.com:9443/ws/ethusdt@trade")
  socket.on_message do |message|
    disruptor.push message
  end
  socket.run
end

while message = disruptor.pop
  puts disruptor.inspect
  puts message
end
