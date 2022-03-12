# Disruptor.cr

An ongoing attempt at implementing the 
[Disruptor pattern](https://martinfowler.com/articles/lmax.html)
for algotrading (and other things) with crystal.

I used this [ruby implementation](https://github.com/ileitch/disruptor) as a guide.

Suggestions for improvements are welcome as an issue.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     disruptor:
       github: nolantait/disruptor.cr
   ```

2. Run `shards install`

## Usage

### Running examples

You can run a live example using Binance websocket to stream
trades using a Channel from two different streams.

To start the example run `crystal examples/binance.cr`

To see how the disruptor handles backpressure you can try the example
`crystal examples/overload.cr`

### Ring buffer

The disruptor pattern uses a ring buffer queue of a fixed size
which manages taking messages from producers and passing them to consumers
without stepping on each others toes.

```crystal
require "disruptor"

# Create a disruptor queue with a length of 1024 items.
# This number must be a power of 2 to exploit performance

disruptor = Disruptor::Queue(String).new(1024)

disruptor.push "Hello"
puts disruptor.pop #=> "Hello"
```

Normally there is a business logic framework wrapped around these queues
which lets you process everything in memory. More to be implemented soon.


### Waiting strategies

Right now there are 3 waiting strategies:

*WaitWithSpin*

From the technical paper:

> Once a producer has copied the relevant data to the claimed entry it can
> make it public to consumers by committing the sequence. This can be done
> without CAS by a simple busy spin until the other producers have reached
> this sequence in their own commit. Then this producer can advance the
> cursor signifying the next available entry for consumption. Producers can
> avoid wrapping the ring by tracking the sequence of consumers as a simple
> read operation before they write to the ring buffer.

```crystal
# Spins in a while loop waiting for the cursors to sync
disruptor = Disruptor::Queue(String).new(1024, Disruptor::WaitWithSpin.new)
```

*WaitWithYield*

From the technical paper:

> Consumers wait for a sequence to become available in the ring buffer before
> they read the entry. Various strategies can be employed while waiting.
> If CPU resource is precious they can wait on a condition variable within a
> lock that gets signalled by the producers. This obviously is a point of
> contention and only to be used when CPU resource is more important than
> latency or throughput. The consumers can also loop checking the cursor which
> represents the currently available sequence in the ring buffer. This could
> be done with or without a thread yield by trading CPU resource against
> latency. This scales very well as we have broken the contended dependency
> between the producers and consumers if we do not use a lock and condition
> variable. Lock free multi-producer – multi-consumer queues do exist but
> they require multiple CAS operations on the head, tail, size counters.
> The Disruptor does not suffer this CAS contention

```crystal
# Yields to the fiber to allow other threads to continue
disruptor = Disruptor::Queue(String).new(1024, Disruptor::WaitWithYield.new)
```

*WaitWithReturn*

Used for running tests.

```crystal
# Returns immediately (used in tests)
disruptor = Disruptor::Queue(String).new(1024, Disruptor::WaitWithReturn.new)
```

## Development

Run benchmarks with `make run_benchmarks`

To test run `crystal specs`

### Current benchmarks:

*Producer/Consumer multithreading with 2 workers*
```
                 user     system      total        real
disruptor:   0.100912   0.067791   0.168703 (  0.169126)
channels:    2.749560   0.082247   2.831807 (  1.617937)
```

*Throughput of simple pop/push in a single thread*
```
  spin disruptor:  21.73M ( 46.02ns) (± 3.46%)  0.0B/op   2.61× slower
 yield disruptor:  21.82M ( 45.83ns) (± 4.91%)  0.0B/op   2.60× slower
return disruptor:  21.89M ( 45.67ns) (± 7.20%)  0.0B/op   2.59× slower
           queue:  54.70M ( 18.28ns) (±12.40%)  0.0B/op   1.04× slower
           array:  56.65M ( 17.65ns) (± 7.54%)  0.0B/op        fastest
```

For comparison to the likely much better performance of the Java implementation see
page 10 of the [Disruptor Technical Paper](https://lmax-exchange.github.io/disruptor/files/Disruptor-1.0.pdf)

Pull requests and discussion are encouraged.

## Contributing

1. Fork it (<https://github.com/nolantait/disruptor.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Nolan J Tait](https://github.com/nolantait) - creator and maintainer
