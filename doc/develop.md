# 未整理的开发文档

> 定时与 Notion 同步

## 0. 前期准备

### 对拍程序

- Makefile [跟我一起写Makefile](https://seisman.github.io/how-to-write-makefile/overview.html)

### 语言+编译链选择

1. 使用 rust
2. 差一个 rust 和 c/cpp 功能/语法糖表格区别

|  |  |
| --- | --- |
|  |  |
|  |  |

3. Rust 学习资料
    - [rCore - 附录 A：Rust 系统编程资料](https://learningos.github.io/rCore-Tutorial-Guide-2023S/appendix-a/index.html) 
    建议先只看[一份简单的 Rust 入门介绍](https://zhuanlan.zhihu.com/p/298648575)
    - https://kaisery.github.io/trpl-zh-cn/ch02-00-guessing-game-tutorial.html 
    首先阅读2/3/4/7/9/10章，这是Rust编写和设计逻辑上和其他语言区别较大的部分。
        - 具体来说，2/3/4章新知识很多，先囫囵吞枣一遍，能让你基本看懂rust源代码
        阅读7章的时候，请和Python的包管理作比较
        阅读9章的时候，请同时参考 [rCore - 移除标准库依赖](https://learningos.github.io/rCore-Tutorial-Guide-2023S/chapter1/2remove-std.html#panic-handler) 和 [rCore - 构建用户态执行环境](https://learningos.github.io/rCore-Tutorial-Guide-2023S/chapter1/3mini-rt-usrland.html#id7)
        阅读10章的时候，希望你对C++(or golang)的泛型有一定了解，不然可以先不看

4. 使用 rustdoc 对代码进行注释

5. 远期预计使用 build2 保留

### VSCode + devcontainer.json

如果不使用VSCode，替代方案：`docker pull tiger3018/oskernel-dev`

流程简介：

1.  clone 源码仓库 `git clone https://github.com/Tiger3018/OSkernel2023-0o1744/`
2. 使用 VSCode 打开文件夹，使用 Remote:Container 插件选择 Open this folder in container
3. `make`（生成测评要求的二进制文件）和 `make qemu`（不生成文件，直接模拟测评机测评过程）

## 1. Boot + Supervisor Mode

### sbi

https://zhuanlan.zhihu.com/p/164394603

https://dingfen.github.io/risc-v/2020/08/05/riscv-privileged.html

https://github.com/riscv-non-isa/riscv-sbi-doc/blob/master/riscv-sbi.pdf

## 2. Process

### model preview

### virtual memory

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/47012f48-ca1a-4c0f-9623-45663a225393/Untitled.png)

TLB快表：

平滑：

![MIT 6.828](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/d8a885a8-30a9-43f1-a4c3-b75997bc96fe/Untitled.png)

MIT 6.828


### time sharing

### multi-programming →multitasking

## 3. Module Call

### syscall

rCore原版代码的问题

[https://gitlab.eduxiji.net/2019301887/oskernel2022-npucore/-/blob/master/Doc/debug/技术细节与错误文档.md](https://gitlab.eduxiji.net/2019301887/oskernel2022-npucore/-/blob/master/Doc/debug/%E6%8A%80%E6%9C%AF%E7%BB%86%E8%8A%82%E4%B8%8E%E9%94%99%E8%AF%AF%E6%96%87%E6%A1%A3.md)

## fat32

找到一篇讲的比较细致的去年开源文档 by zbh

[Doc/fs/fat.md · master · tempdragon / OSKernel2022-NPUcore · GitLab](https://gitlab.eduxiji.net/2019301887/oskernel2022-npucore/-/blob/master/Doc/fs/fat.md)

我其实一直在想同时实现fat16/32/exfat有没有意义，效果大不大

而这篇就只是讲了异步，没啥参考意义

[doc/第六章-异步fat32文件系统.md · main · 无相之风战队 / 华中科技大学-无相之风战队-proj68 · GitLab](https://gitlab.eduxiji.net/luojia65/project325618-85616/-/tree/main/doc/%E7%AC%AC%E5%85%AD%E7%AB%A0-%E5%BC%82%E6%AD%A5fat32%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F.md)

## 4. 软件使用

### rustc

https://github.com/dtolnay/cargo-expand/issues/113#issuecomment-1464948209

`RUSTC_BOOTSTRAP=1`

`rust-project.json`

https://danielmangum.com/posts/risc-v-bytes-rust-cross-compilation/

- Bug #不要管
    
    https://clang.llvm.org/docs/CrossCompilation.html#target-triple
    
    https://rustc-dev-guide.rust-lang.org/building/new-target.html
    
    https://github.com/rust-lang/rust/pull/58406/files
    
    [https://github.com/rust-lang/rust/blame/2913ad6db0f72fed5139253faed73200c7af3535/compiler/rustc_target/src/spec/riscv64gc_unknown_none_elf.rs](https://github.com/rust-lang/rust/blame/2913ad6db0f72fed5139253faed73200c7af3535/compiler/rustc_target/src/spec/riscv64gc_unknown_none_elf.rs#L4)
    

### qemu

^]A + X

### build2

https://build2.org/faq.xhtml#ninja 

https://build2.org/build2/doc/build2-build-system-manual-a4.pdf https://build2.org/build2/doc/build2-build-system-manual.xhtml

https://build2.org/build2-toolchain/doc/build2-toolchain-install-a4.pdf

## 5. 参考文档

https://os.phil-opp.com/zh-CN/

https://0xax.gitbooks.io/linux-insides/content/Initialization/linux-initialization-1.html

https://github.com/janaSunrise/rust-64-bit-os