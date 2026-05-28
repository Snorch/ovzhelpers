---
name: kernel-docker-build
description: Build the Linux kernel (or selftests, modules, individual .o files) using the user's helper script kernel-build, which helps run build in docker container with preinstalled build environment. Use when the user asks to build, compile, or sanity-check code while in kernel repo — including targeted object builds, full kernel images, modules, or kselftests under `tools/testing/selftests/`. Do NOT use to run kernel tests (the host kernel may differ from the source tree; the user runs tests themselves).
---

# Kernel build via docker toolchain

The user's `~/bin/build-kernel` script runs a docker container with the full toolchain pre-installed. Always use it — do not run `make` directly on the host. Invoke from the kernel source root (so `$PWD` has the top-level `Makefile`); the script auto-prepends `cd /kernel` and prints `>>> SUCCESS <<<` on success.

For agent use, always pass commands via `-c` (the bare form builds full kernel interactively and is not intended to be used in scripts). Examples:

```bash
~/bin/build-kernel -c "make -j\$(nproc) kernel/ve/ve.o kernel/bpf/syscall.o"   # targeted objects, fastest
~/bin/build-kernel -c "cd tools/testing/selftests/ve_devcg_bpf && make"        # selftest
~/bin/build-kernel -c "make -j\$(nproc)"                                       # full image — takes very long; try to avoid; confirm first
```

Escape `\$(nproc)` so it expands inside the container. Pipe through `tail -20` to trim the docker-build preamble. After the build, do not run the kernel or selftests on the host — the host kernel may differ from the source tree; the user tests in their own VM.
