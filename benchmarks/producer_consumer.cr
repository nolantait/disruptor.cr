require "benchmark"

require "../src/disruptor"

n = 16777216
half = 8388608

Benchmark.bm do |x|
  x.report("disruptor:") do
    disruptor = Disruptor::Queue(Int32).new(n, Disruptor::WaitWithYield.new)

    spawn do
      half.times do
        disruptor.push rand(1..100)
      end
    end

    spawn do
      half.times do
        disruptor.push rand(1..100)
      end
    end

    spawn do
      n.times do
        disruptor.pop
      end
    end

    Fiber.yield
  end

  x.report("channels:") do
    channel = Channel(Int32).new(n)

    spawn do
      half.times do
        channel.send rand(1..100)
      end
    end

    spawn do
      half.times do
        channel.send rand(1..100)
      end
    end

    n.times { channel.receive }
  end
end
