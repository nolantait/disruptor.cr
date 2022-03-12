SHELL=/bin/sh

run_benchmarks:
	echo "Building benchmarks..."
	crystal build -Dpreview_mt benchmarks/producer_consumer.cr --release -p -o build/benchmarks-producer-consumer
	crystal build -Dpreview_mt benchmarks/throughput.cr --release -p -o build/benchmarks-throughput
	echo "Running benchmarks..."
	CRYSTAL_WORKERS=2 ./build/benchmarks-producer-consumer
	./build/benchmarks-throughput
