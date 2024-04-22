**The Dockerfile includes:**

1. Ubuntu 22.04
   - tmux 3.2a
3. Simulation software:
   - Verilator 5.024 2024-04-05 rev v5.024-42-gc561fe8ba
   - Icarus Verilog version 12.0
   - GTKWave Analyzer v3.3.104 (Waveform viewer)

4. Editor software:
   - Emacs 29.3 with Verilog-mode 2024-03-01-7448f97-vpo-GNU
   - Vim 8.2
   - Gvim 8.2
   - Neovim 0.9.5 with Verilog/SystemVerilog support using Verible ([Read more](https://github.com/chipsalliance/verible))
   - Meld 3.20.4
   - Git 2.34.1
   - tcl 8.2

### How to build the Docker container:
```bash
docker buildx build --rm --tag verilator --file ./Dockerfile .
```

### How to run
```bash
docker run -ti --env DISPLAY=host.docker.internal:0 -v yourlocalDir:/workDir --hostname verilator verilator /usr/bin/bash
```

### Note
In Windows environment host please install && run this software first

[Windows X-server](https://github.com/marchaesen/vcxsrv)
