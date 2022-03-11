module Disruptor
  class Sequence
    getter cursor

    def initialize(start : Int32 = 0)
      @cursor = Atomic(Int32).new(start)
    end

    def get
      @cursor.get
    end

    def add(n)
      @cursor.add(n)
    end

    def set(current_value, new_value)
      until @cursor.compare_and_set(current_value, new_value); end
    end

    def increment
      loop do
        current_seq = @cursor.get
        next_seq = current_seq + 1
        return current_seq if @cursor.compare_and_set(current_seq, next_seq)
      end
    end
  end
end
