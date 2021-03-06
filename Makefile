include configuration.mk

push: build
	rsync -avz preprocessor/linux/ $(REMOTE_SERVER)

build: preprocessor/linux/64/dynare preprocessor/linux/32/dynare
	rm -rf dynare

dynare/README.md:
	git clone --recursive --depth=1 -b $(GIT_BRANCH) $(GIT_REMOTE)

preprocessor/linux/64/dynare: dynare/README.md
	mkdir -p preprocessor/linux/64
	cd dynare && git clean -fd
	cd dynare && autoreconf -si && ./configure --disable-octave --disable-matlab LDFLAGS='-static -static-libgcc -static-libstdc++' && cd preprocessor && make all && mkdir -p ../../preprocessor && mv dynare_m ../../preprocessor/linux/64/dynare

preprocessor/linux/32/dynare: dynare/README.md
	mkdir -p preprocessor/linux/32
	cd dynare && make clean
	cd dynare && autoreconf -si && ./configure --disable-octave --disable-matlab LDFLAGS='-m32 -static -static-libgcc -static-libstdc++' CFLAGS='-m32' CPPFLAGS='-m32' && cd preprocessor && make all && mkdir -p ../../preprocessor && mv dynare_m ../../preprocessor/linux/32/dynare

clean:
	rm -f preprocessor/linux/32/dynare
	rm -f preprocessor/linux/64/dynare
