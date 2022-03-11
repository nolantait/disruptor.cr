require "log"

require "../src/disruptor"

n = 2048
half = 1024
value = "Hello"

disruptor = Disruptor::Queue(String).new(n)

spawn do
  loop do
    disruptor.push(value)
    disruptor.push(value)
    Fiber.yield
  end
end

spawn do
  loop do
    disruptor.push(value)
    disruptor.push(value)
    Fiber.yield
  end
end

spawn do
  loop do
    disruptor.pop
    Fiber.yield
  end
end

spawn do
  loop do
    disruptor.pop
    Fiber.yield
  end
end

loop do
  puts disruptor.inspect
  Fiber.yield
end
