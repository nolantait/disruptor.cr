require "log"

require "../src/disruptor"

n = 2048
disruptor = Disruptor::Queue(Int32).new(n, Disruptor::WaitWithYield.new)

spawn do
  loop do
    rand(1..100).times do
      disruptor.push rand(1..100)
    end

    sleep rand(0.01..0.1)
  end
end

spawn do
  loop do
    rand(1..100).times do
      disruptor.push rand(1..100)
    end

    sleep rand(0.01..0.1)
  end
end

while message = disruptor.pop
  puts disruptor.inspect
  puts message
end
