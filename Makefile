download:
	@[ -d zenoh ] || git clone https://github.com/eclipse-zenoh/zenoh
	@[ -d zenoh-pico ] || git clone https://github.com/eclipse-zenoh/zenoh-pico
	@echo 'zenoh & zenoh-pico have already been downloaded.'

pull:
	git -C zenoh pull
	git -C zenoh-pico pull

select_commits:
	./setup-commits.sh

build_zenoh:
	./build-commits.sh

build_pico:
	./build-pico.sh

benchmark:
	sudo ./benchmark.sh

plot:
	./plot.py

setup_python_lib:
	./setup-python.sh

setup_all: download select_commits build_zenoh build_pico setup_python_lib
	@echo 'Setting up everything ...'

run_all: benchmark plot
	@echo 'Start the benchmark and then plot the results.'
