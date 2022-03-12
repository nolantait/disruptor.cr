require "benchmark"

require "../src/disruptor"

iterations = 500_000
n = 2048
value = 0

Benchmark.ips do |x|
  spin_disruptor = Disruptor::Queue(Int32).new(n, Disruptor::WaitWithSpin.new)
  yield_disruptor = Disruptor::Queue(Int32).new(n, Disruptor::WaitWithYield.new)
  return_disruptor = Disruptor::Queue(Int32).new(n, Disruptor::WaitWithReturn.new)
  queue = Deque(Int32).new(n)
  array = Array(Int32).new(n)

  x.report("spin disruptor:") do
    iterations.times do
      spin_disruptor.push(value)
      spin_disruptor.pop
    end
  end

  x.report("yield disruptor:") do
    iterations.times do
      yield_disruptor.push(value)
      yield_disruptor.pop
    end
  end

  x.report("return disruptor:") do
    iterations.times do
      return_disruptor.push(value)
      return_disruptor.pop
    end
  end

  x.report("           queue:") do
    iterations.times do
      queue.push(value)
      queue.pop
    end
  end

  x.report("           array:") do
    iterations.times do
      array.push(value)
      array.pop
    end
  end
end
