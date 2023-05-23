
# bullseye 11
FROM debian:bullseye-slim AS build2-compile
WORKDIR /root
RUN apt-get update \
&&  apt-get install curl ca-certificates clang-13 git --no-install-recommends -y \
&&  apt-get clean \
&&  rm -rf /var/lib/apt/lists
RUN curl -sSfO https://download.build2.org/0.15.0/build2-install-0.15.0.sh \
&&  mkdir -p /root/.local \
&&  sh build2-install-0.15.0.sh --yes --stage-suffix "-stage" --cxx clang++-13 --private --trust yes /root/.local
ENV PATH=/root/.local/bin:${PATH}
RUN mkdir /root/bpkg-ws && cd /root/bpkg-ws \
&&  bpkg create config.cxx=clang++-13 cc \
# &&  bpkg add https://pkg.cppget.org/1/alpha/ \
&&  bpkg add https://github.com/tiger3018/libbuild2-rust.git#0.15 \
&&  bpkg fetch --trust-yes -v \
&&  bpkg build -v config.cxx=clang++-13 -- libbuild2-rust 

# bullseye 11
FROM debian:bullseye-slim 
RUN echo "deb http://deb.debian.org/debian bullseye-backports main" >> /etc/apt/sources.list \
&&  apt-get update \
&&  apt-get install curl ca-certificates make patch perl file gdb-multiarch binutils binutils-riscv64-linux-gnu g++-riscv64-linux-gnu qemu-system-misc zsh git --no-install-recommends -y \
&&  apt-get install qemu-system-misc/bullseye-backports --no-install-recommends -y \
&&  apt-get autoremove -y \
&&  apt-get clean \
&&  rm -rf /var/lib/apt/lists
ENV PATH=/root/.cargo/bin:/root/.local/bin:${PATH}
RUN curl https://sh.rustup.rs | sh -s -- -y --no-modify-path --profile=minimal \
&&  rustup target remove x86_64-unknown-linux-gnu \
&&  rustup target add riscv64gc-unknown-linux-gnu riscv64gc-unknown-none-elf \
&&  rustup component add llvm-tools-preview \
# https://github.com/rust-lang/rustup/pull/2046
&&  rustup update
COPY --from=build2-compile /root/.local /root/.local
COPY --from=build2-compile /root/bpkg-ws /root/bpkg-ws
RUN mkdir /root/.build2 \
&&  echo "!config.import.libbuild2_rust = /root/bpkg-ws" >> /root/.build2/b.options \
&&  echo "#!config.import.build2 = /root/.local/share/doc/build2/" >> /root/.build2/b.options \
&&  echo "#!config.c = gcc-10" >> /root/.build2/b.options \
&&  echo "#!config.cxx = g++-10" >> /root/.build2/b.options \
&&  echo "#!config.cxx.id = gcc" >> /root/.build2/b.options 
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
&&  echo -e "zstyle ':omz:update' mode disabled\nsetopt autocd\nsetopt correct\nsetopt interactivecomments\nsetopt magicequalsubst\nsetopt numericglobsort\nsetopt promptsubst" && cat /root/.zshrc | tee /root/.zshrc \
&&  sed -i "s#plugins=(git)#plugins=(git git-escape-magic command-not-found history history-substring-search isodate scd shell-proxy z)#" /root/.zshrc 

ENV RUSTUP_UPDATE_ROOT=https://mirrors.nju.edu.cn/rustup