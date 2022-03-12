module Disruptor
  class Ring(T)
    # Implementation of an n-writer ring buffer

    getter buffer, cursor, next_cursor

    def initialize(
      @size : Int,
      @wait_strategy : WaitStrategy = WaitWithSpin.new
    )
      raise BufferSizeError.new unless power_of_two?(@size)

      @cursor = Sequence.new(-1)
      @next_cursor = Sequence.new(0)
      @buffer = Array(T | Nil).new(@size) do |index|
        nil
      end
    end

    def initialize(
      @size : Slot,
      @wait_strategy : WaitStrategy = WaitWithSpin.new,
      &block
    )
      raise BufferSizeError.new unless power_of_two?(@size)

      @cursor = Sequence.new(-1)
      @next_cursor = Sequence.new(0)
      @buffer = Array(T).new(@size, &block)
    end

    def claim
      @next_cursor.increment
    end

    def commit(slot : Slot)
      if @cursor.get != -1 && slot != 0
        @wait_strategy.wait_for(@cursor, slot - 1)
      end

      @cursor.set(slot - 1, slot)
    end

    def set(slot : Slot, value : T)
      @buffer[slot % @size] = value
    end

    def get(slot : Slot) : T
      value = @buffer[slot % @size]
      raise Exception.new unless value

      return value
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
