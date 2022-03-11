module Disruptor
  VERSION = "0.1.0"

  class BufferSizeError < Exception; end
  alias Slot = Int::Signed
  alias Sequence = Atomic(Int32)
end

require "./disruptor/ring"
require "./disruptor/queue"
