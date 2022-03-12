module Disruptor
  class ProcessorBarrier(T)
    def initialize(@buffer : Ring(T), @wait_strategy : WaitStrategy)
      @last_known_sequence = -1
    end

    def wait_for(sequence : Int32)
      # Optimization:
      # Store the last known cursor value in local memory to avoid
      # going down into the primitive Sequence#get.
      return if sequence < @last_known_sequence

      @wait_strategy.wait_for(@buffer.cursor, sequence)
      @last_known_sequence = @buffer.cursor.get
    end
  end
end
