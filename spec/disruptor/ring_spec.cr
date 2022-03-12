require "../spec_helper"

describe Disruptor::Ring do
  describe "initialize" do
    it "raises an error when initialized with a size that is not a power of two" do
      expect_raises Disruptor::BufferSizeError do
        Disruptor::Ring(String).new(31)
      end
    end

    it "accepts a power of two" do
      Disruptor::Ring(String).new(32).should be_a Disruptor::Ring(String)
    end
  end

  describe "#set and #get" do
    it "allows setting and getting values" do
      ring = Disruptor::Ring(String).new(32)
      ring.set(1, "Hello")
      ring.get(1).should eq "Hello"
    end
  end

  describe "#claim" do
    it "increments the cursor" do
      ring = Disruptor::Ring(String).new(32)
      ring.next_cursor.get.should eq 1
      ring.claim
      ring.next_cursor.get.should eq 2
    end
  end
end
