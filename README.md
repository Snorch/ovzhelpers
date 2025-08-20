# Install ##

```
git clone https://github.com/Snorch/ovzhelpers.git && cd ovzhelpers && ./install.sh
```

## Kernel building and installation

### 0. Prerequisites

Install docker, see https://docs.docker.com/engine/install/

Create ccache directory (will speed up consecutive builds):

```
mkdir ~/.ccache
echo "max_size=120G" > ~/.ccache/ccache.conf
```

### 1. Clone kernel
```
mkdir /vz/build
cd /vz/build
# For example let's get mainstream kernel from official github mirror
git clone https://github.com/torvalds/linux.git --single-branch --branch master
```

### 2. Setup nfs for your subnet (accross which you would be installing kernel)
```
nfs-export-dir.sh /vz/build <ip/mask>
```

### 3. Get kernel config
```
# For example from you current kernel
zcat /proc/config.gz > /vz/build/linux/.config
```

### 4. Build kernel
```
cd /vz/build/linux
# Provide short name suffix to your kernel
build-kernel [name-suffix]
# It may interractivly ask for extra config options, just press enter to accept defaults
```

Under the hood it would create a docker container with needed dependencies to build kernel. Next it would run kmake script which does actual kernel building and puts debug symbols separately to decrease kernel instalation size.

### 5. Install kernel

Go to the VM or HW node you'd like to install kernel to.
```
kinst <builder-ip>:/vz/build/linux
```

Under the hood it would create nfs mount and overlayfs mount on top of it, to make it writable, and then perform regular kernel instalation.

Note that the script output will give usefull instruction on setting up debug symbols for perf and crash, in case you need them.

### 6. Reboot.

New kernel will be loaded once. On the next reboot old default kernel will be loaded, in case new kernel fails to boot.
