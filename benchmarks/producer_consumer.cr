require "benchmark"

require "../src/disruptor"

n = 1048576
half = 524288
value = "Hello"

Benchmark.bm do |x|
  disruptor = Disruptor::Queue(String).new(n)
  queue = Deque(String).new(n)
  array = Array(String).new(n)

  x.report("concurrent disruptor:") do
    spawn do
      half.times do
        disruptor.push(value)
      end
    end

    spawn do
      half.times do
        disruptor.push(value)
      end
    end

    spawn do
      half.times do
        disruptor.pop
      end
    end

    spawn do
      half.times do
        disruptor.pop
      end
    end

    Fiber.yield
  end

  x.report("     basic disruptor:") do
    n.times do
      disruptor.push(value)
    end

    n.times do
      disruptor.pop
    end
  end

  x.report("               queue:") do
    n.times do
      queue.push(value)
    end

    n.times do
      queue.pop
    end
  end

  x.report("               array:") do
    n.times do
      array.push(value)
    end

    n.times do
      array.pop
    end
  end
end
