module Disruptor
  VERSION = "0.1.0"

  class BufferSizeError < Exception; end
  alias Slot = Int8 | Int16 | Int32
end

require "./disruptor/sequence"
require "./disruptor/ring"
require "./disruptor/queue"
