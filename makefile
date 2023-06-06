# See <https://seisman.github.io/how-to-write-makefile/introduction.html>
# See <https://github.com/rust-lang/rfcs/pull/940>
BINARY_CRATE_NAME = $(shell grep 'exe{\w*}:' buildfile | awk -F'[{}]' '{print $$2}')
BINARY_NAME ?= kernel-qemu
BUILD2_PATH ?= /root/.local/bin/
BUILD2_NAME ?= b
OSCOMP_SD_CARD_IMG ?= sdcard.img
RUST_CRATE_MAIN = $(shell grep 'exe{\w*}:' buildfile | awk -F'[{}]' '{print $$(NF -1)}').rs
RUSTC_EDITION = $(shell grep edition buildfile | awk -F' ' '{print $$(NF +0)}')
RUSTC_DEF ?= RUSTC_BOOTSTRAP=1

export PATH := $(BUILD2_PATH):$(PATH)

# Avoid something is up to date
.PHONY: rustdoc build2 build2-3rdparty make-3rdparty clean clean-project clean-3rdparty qemu test-copy

all: build2 hyphen-move

doc: rustdoc
	$(info [HINTS] doc is an alias of rustdoc)

rustdoc:
	$(RUSTC_DEF) rustdoc $(RUST_CRATE_MAIN) --document-private-items --edition $(RUSTC_EDITION) --crate-name ${BINARY_CRATE_NAME} -o rustdoc ${TODO_BEGIN} -L crate=./3rdparty/ --target=riscv64gc-unknown-none-elf

# Since libbuild2-rust can't determine the package's status
# We should remove the binary and ignore the possible NOT FOUND error.
#	-rm $(BINARY_NAME);
build2: clean-project 3rdparty/
	$(BUILD2_NAME);

build2-3rdparty:
	$(BUILD2_NAME) 3rdparty/
make-3rdparty:
	cd ./3rdparty/ && make
3rdparty/: make-3rdparty

clean: clean-project clean-3rdparty
clean-project:
	rm -f ${BINARY_CRATE_NAME} ${BINARY_NAME}
clean-3rdparty:
	rm -f 3rdparty/*.rlib
	rm -f 3rdparty/*/Cargo.lock
	rm -rf 3rdparty/*/target

hyphen-move: 
	mv $(BINARY_CRATE_NAME) $(BINARY_NAME);

qemu: all
	qemu-system-riscv64 -nographic -machine virt \
	-kernel $(BINARY_NAME) -m 128M -smp 2 
#	-drive file=$(OSCOMP_SD_CARD_IMG),if=none,format=raw,id=x0 \
#	-device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0
#	-kernel $(BINARY_NAME) -append "root=/dev/vda ro console=ttyS0"

test-copy: 
	tar -C / -xf ./offline/tar/ws.tar
	tar -xf ./offline/tar/3rdparty.tar