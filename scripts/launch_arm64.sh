#!/bin/bash
set -e

SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $SCRIPTDIR/calaos_lib.sh

disk=$outdir/calaos-os.hddimg

# truncate -s 64m varstore.img
# truncate -s 64m efi.img 
# dd if=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd of=efi.img conv=notrunc

# cp varstore.img efi.img $outdir

qemu-system-aarch64 -M virt \
    -machine virtualization=true -machine virt,gic-version=3  \
    -cpu max -smp 2 -m 4096 \
    -drive if=pflash,format=raw,file=efi.img,readonly \
    -drive if=pflash,format=raw,file=varstore.img\
    -device virtio-blk-device,drive=disk1 \
    -drive id=disk1,file=out/calaos-os.hddimg,if=none \
    -object rng-random,filename=/dev/urandom,id=rng0 \
    -device virtio-rng-pci,rng=rng0 \
    -nographic \
    -serial mon:stdio \
