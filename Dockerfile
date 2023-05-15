
# bullseye 11
FROM debian:bullseye-slim AS build2-compile
WORKDIR /root
RUN apt-get update \
&&  apt-get install curl ca-certificates clang-13 git --no-install-recommends -y \
&&  apt-get clean
RUN curl -sSfO https://download.build2.org/0.15.0/build2-install-0.15.0.sh \
&&  mkdir -p /root/.local \
&&  sh build2-install-0.15.0.sh --yes --stage-suffix "s" --cxx clang++-13 --private --trust yes /root/.local
#ENV PATH=/root/.local/bin:${PATH}

# bullseye 11
FROM debian:bullseye-slim 
RUN apt-get update \
&&  apt-get install curl ca-certificates build-essential gdb-multiarch g++-riscv64-linux-gnu binutils-riscv64-linux-gnu qemu-system-misc zsh git --no-install-recommends -y \
&&  apt-get clean
ENV PATH=/root/.cargo/bin:/root/.local/bin:${PATH}
RUN curl https://sh.rustup.rs | sh -s -- -y --no-modify-path --profile=minimal \
&&  rustup target remove x86_64-unknown-linux-gnu \
&&  rustup target add riscv64gc-unknown-linux-gnu riscv64gc-unknown-none-elf \
&&  rustup component add llvm-tools-preview \
# https://github.com/rust-lang/rustup/pull/2046
&&  rustup update
COPY --from=build2-compile /root/.local /root/.local
RUN mkdir /root/.build2 \
&&  echo "!config.import.libbuild2_rust = /root/bpkg-ws" >> /root/.build2/b.options \
&&  echo "#!config.import.build2 = /root/.local/share/doc/build2/" >> /root/.build2/b.options \
&&  echo "#!config.c = gcc-10" >> /root/.build2/b.options \
&&  echo "#!config.cxx = g++-10" >> /root/.build2/b.options \
&&  echo "#!config.cxx.id = gcc" >> /root/.build2/b.options 
RUN mkdir /root/bpkg-ws && cd /root/bpkg-ws \
&&  bpkg create config.cxx=g++-10 cc \
&&  bpkg add https://pkg.cppget.org/1/alpha/ \
&&  bpkg add https://github.com/tiger3018/libbuild2-rust.git#0.15 \
&&  bpkg fetch --trust-yes -v \
&&  bpkg build -v config.cxx=g++-10 -- libbuild2-rust 

ENV RUSTUP_UPDATE_ROOT=https://mirrors.nju.edu.cn/rustup