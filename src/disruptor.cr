require "./disruptor/wait_with_yield"
require "./disruptor/wait_with_spin"
require "./disruptor/wait_with_return"
require "./disruptor/sequence"
require "./disruptor/processor_barrier"
require "./disruptor/ring"
require "./disruptor/queue"

module Disruptor
  VERSION = "0.1.0"

  class BufferSizeError < Exception; end
  alias Slot = Int8 | Int16 | Int32
  alias WaitStrategy = WaitWithSpin | WaitWithYield | WaitWithReturn
end
