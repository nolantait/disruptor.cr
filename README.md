# Disruptor.cr

An ongoing attempt at implementing the [Disruptor pattern](https://martinfowler.com/articles/lmax.html)
for algotrading with crystal.

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

You can run a live example using Binance websocket to stream
trades using a Channel from two different streams.

To start the example run `crystal examples/binance.cr`

To see how the disruptor handles backpressure you can try the example
`crystal examples/overload.cr`

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

## Development

Run benchmarks with `crystal benchmarks/producer_consumer.cr`

To test run `crystal specs`

### Current benchmarks:

*Producer/Consumer*
```
                            user     system      total        real
concurrent disruptor:   1.877195   0.010555   1.887750 (  2.097337)
     basic disruptor:   1.504052   0.007077   1.511129 (  1.520054)
               queue:   0.574990   0.002785   0.577775 (  0.582177)
               array:   0.607392   0.004656   0.612048 (  0.617646)
```

*Throughput of simple pop/push*
```
 disruptor:   4.08k (245.07µs) (± 4.11%)  0.0B/op   3.74× slower
     queue:  15.26k ( 65.53µs) (± 2.54%)  0.0B/op        fastest
     array:  14.21k ( 70.35µs) (± 3.38%)  0.0B/op   1.07× slower
```

For comparison to the much better performance of the Java implementation see
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
