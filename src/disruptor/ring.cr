module Disruptor
  class Ring(T)
    def initialize(@size : Slot, block = ->(i : Slot) { T.new })
      raise BufferSizeError.new unless power_of_two?(size)

      @buffer = Array(T).new(size, &block)
    end

    def set(slot : Slot, value : T)
      @buffer[slot % @size] = value
    end

    def get(slot : Slot)
      @buffer[slot % @size]
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
