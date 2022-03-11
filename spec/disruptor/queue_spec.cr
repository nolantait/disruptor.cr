require "../spec_helper"

describe Disruptor::Queue do
  it "initializes with a valid size" do
    Disruptor::Queue(String).new(1).should be_a Disruptor::Queue(String)
  end

  it "pushes and pops a value from the queue" do
    queue = Disruptor::Queue(String).new(1)
    queue.push("Hello")
    queue.pop.should eq "Hello"
  end
end
