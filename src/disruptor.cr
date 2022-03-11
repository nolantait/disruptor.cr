require "./disruptor/ring"

module Disruptor
  VERSION = "0.1.0"

  class BufferSizeError < Exception; end
  alias Slot = Int64 | Int32 | Int16 | Int8
end
