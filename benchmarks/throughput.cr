require "benchmark"

require "../src/disruptor"

n = 2048
value = 0

Benchmark.ips do |x|
  disruptor = Disruptor::Queue(Int32).new(n)
  queue = Deque(Int32).new(n)
  array = Array(Int32).new(n)

  x.report("disruptor:") do
    n.times do
      disruptor.push(value)
      disruptor.pop
    end
  end

  x.report("     queue:") do
    n.times do
      queue.push(value)
      queue.pop
    end
  end

  x.report("     array:") do
    n.times do
      array.push(value)
      array.pop
    end
  end
end
