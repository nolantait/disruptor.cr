require "benchmark"

require "../src/disruptor"

n = 2048

Benchmark.ips do |x|
  spin_disruptor = Disruptor::Queue(Int32).new(n, Disruptor::WaitWithSpin.new)
  yield_disruptor = Disruptor::Queue(Int32).new(n, Disruptor::WaitWithYield.new)
  return_disruptor = Disruptor::Queue(Int32).new(n, Disruptor::WaitWithReturn.new)
  queue = Deque(Int32).new(n)
  array = Array(Int32).new(n)

  x.report("spin disruptor:") do
    spin_disruptor.push rand(1..100)
    spin_disruptor.pop
  end

  x.report("yield disruptor:") do
    yield_disruptor.push rand(1..100)
    yield_disruptor.pop
  end

  x.report("return disruptor:") do
    return_disruptor.push rand(1..100)
    return_disruptor.pop
  end

  x.report("           queue:") do
    queue.push rand(1..100)
    queue.pop
  end

  x.report("           array:") do
    array.push rand(1..100)
    array.pop
  end
end
