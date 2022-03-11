module Disruptor
  class Queue(T)
    def initialize(size : Slot)
      @buffer = Ring(T).new(size)
      @sequence = Sequence.new(0)
    end

    def push(value : T)
      cursor = @buffer.claim
      @buffer.set(cursor, value)
      @buffer.commit(cursor)
    end

    def pop
      next_sequence = @sequence.increment
      while @buffer.cursor.get < next_sequence; end
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
