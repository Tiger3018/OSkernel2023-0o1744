OFFLINE_ARGUMENT ?= --offline
RUSTC_DEF ?= RUSTC_BOOTSTRAP=1

.PHONY: build2 cargo

all: cargo

build2:
	b;

cargo: # Stop if any package failed.
	cd bitflags && \
	$(RUSTC_DEF) cargo b --target=riscv64gc-unknown-none-elf --no-default-features $(OFFLINE_ARGUMENT) --out-dir ../ -Z unstable-options && \
	cd ../maturin-rust-fatfs && \
	$(RUSTC_DEF) cargo b --target=riscv64gc-unknown-none-elf --no-default-features $(OFFLINE_ARGUMENT) --out-dir ../ -Z unstable-options && \
	cd ../riscv && \
	$(RUSTC_DEF) cargo b --target=riscv64gc-unknown-none-elf --no-default-features $(OFFLINE_ARGUMENT) --out-dir ../ -Z unstable-options