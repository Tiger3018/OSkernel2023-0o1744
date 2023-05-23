# See <https://seisman.github.io/how-to-write-makefile/introduction.html>
# See <https://github.com/rust-lang/rfcs/pull/940>
BINARY_CRATE_NAME = $(shell grep exe buildfile | awk -F'[{}]' '{print $$2}')
BINARY_NAME = kernel-qemu
#BUILD2_PATH = /root/.local/bin/
#BUILD2_NAME = b
OSCOMP_SD_CARD_IMG = sdcard.img
RUST_CRATE_MAIN = $(shell grep exe buildfile | awk -F'[{}]' '{print $$(NF -1)}').rs
RUSTC_EDITION = $(shell grep edition buildfile | awk -F' ' '{print $$(NF +0)}')
RUSTC_DEF = RUSTC_BOOTSTRAP=1

.PHONY: doc build2 qemu

all: build2 hyphen-move

doc:
	$(RUSTC_DEF) rustdoc $(RUST_CRATE_MAIN)  --document-private-items --edition $(RUSTC_EDITION) -o target/doc

# Since libbuild2-rust can't determine the package's status
# We should remove the binary and ignore the possible NOT FOUND error.
#	-rm $(BINARY_NAME);
build2:
	b;

hyphen-move: 
	mv $(BINARY_CRATE_NAME) $(BINARY_NAME);

qemu:
	qemu-system-riscv64 -nographic -machine virt \
	-kernel $(BINARY_NAME) -m 128M -smp 2 \
	-drive file=$(OSCOMP_SD_CARD_IMG),if=none,format=raw,id=x0 \
	-device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0
#	-kernel $(BINARY_NAME) -append "root=/dev/vda ro console=ttyS0"