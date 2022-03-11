module Disruptor
  class Queue(T)
    def initialize(size : Slot)
      @buffer = Ring(T).new(size)
      @sequence = Sequence.new(0)
      @committed_count = 0
    end

    def push(value : T)
      cursor = @buffer.claim
      @buffer.set(cursor, value)
      @buffer.commit(cursor)
      @committed_count += 1
    end

    def pop
      next_sequence = @sequence.add(1)
      @buffer.get(next_sequence)
    end

    def inspect
      "<Disruptor::Queue length: #{length}>"
    end

    def length
      @committed_count - @sequence.get
    end
  end
end
