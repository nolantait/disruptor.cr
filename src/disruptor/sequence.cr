module Disruptor
  class Sequence
    def initialize(@cursor : Slot)
      @cursor
    end

    def get
      @cursor
    end

    def add(n)
      @cursor += n
    end

    def set(n)
      @cursor = n
    end
  end
end
