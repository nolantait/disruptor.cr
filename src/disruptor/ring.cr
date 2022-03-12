module Disruptor
  class Ring(T)
    # Implementation of an n-writer ring buffer

    getter buffer, cursor, next_cursor

    def initialize(@size : Int)
      raise BufferSizeError.new unless power_of_two?(@size)

      @cursor = Sequence.new(0)
      @next_cursor = Sequence.new(1)
      @buffer = Array(T | Nil).new(@size) do |index|
        nil
      end
    end

    def initialize(@size : Slot, &block)
      raise BufferSizeError.new unless power_of_two?(@size)

      @cursor = Sequence.new(0)
      @next_cursor = Sequence.new(1)
      @buffer = Array(T).new(@size, &block)
    end

    def claim
      @next_cursor.increment
    end

    def commit(slot : Slot)
      @cursor.set(slot - 1, slot)
    end

    def set(slot : Slot, value : T)
      @buffer[slot % @size] = value
    end

    def get(slot : Slot)
      @buffer[slot % @size]
    end

    def claimed_count
      @next_cursor.get - @cursor.get - 1
    end

    def committed_count
      @cursor.get + 1
    end

    private def power_of_two?(number)
      loop do
        return true if number == 1
        return false if number % 2 != 0

        number = number / 2
      end
    end
  end
end
