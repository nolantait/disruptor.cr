module Disruptor
  class Queue(T)
    def initialize(size : Slot, wait_strategy : WaitStrategy = WaitWithSpin.new)
      @buffer = Ring(T).new(size, wait_strategy)
      @sequence = Sequence.new(0)
      @barrier = ProcessorBarrier(T).new(@buffer, wait_strategy)
    end

    def push(value : T)
      cursor = @buffer.claim
      @buffer.set(cursor, value)
      @buffer.commit(cursor)
      nil
    end

    def pop : T
      next_sequence = @sequence.increment
      @barrier.wait_for(next_sequence)
      @buffer.get(next_sequence)
    end

    def inspect
      "<Disruptor::Queue buffer: #{@buffer.buffer.size}, size: #{length}>"
    end

    def length
      @buffer.committed_count - @sequence.get
    end
  end
end
