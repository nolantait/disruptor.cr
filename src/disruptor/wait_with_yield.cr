module Disruptor
  class WaitWithYield
    def wait_for(cursor : Sequence, sequence : Int32)
      while cursor.get < sequence
        Fiber.yield
      end
    end
  end
end
