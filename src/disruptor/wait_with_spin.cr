module Disruptor
  class WaitWithSpin
    def wait_for(cursor : Sequence, sequence : Int32)
      while cursor.get < sequence; end
    end
  end
end
