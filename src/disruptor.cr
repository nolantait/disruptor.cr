module Disruptor
  VERSION = "0.1.0"

  class BufferSizeError < Exception; end
  alias Slot = Int::Signed
end

require "./disruptor/sequence"
require "./disruptor/ring"
require "./disruptor/queue"
