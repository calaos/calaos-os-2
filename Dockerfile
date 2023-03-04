FROM debian:stable

ARG UID=1001
ARG GID=1001
ARG USER=build

RUN echo 'deb http://deb.debian.org/debian bullseye-backports main contrib non-free' >> /etc/apt/sources.list

RUN apt -y update && \
    apt -y upgrade && \
    apt-get install -yq --no-install-recommends ca-certificates wget gnupg \
        git fakeroot build-essential sudo nano mtools syslinux-common syslinux-efi parted \
        qemu-system-aarch64 qemu-system-x86 fdisk udev dosfstools qemu-efi qemu-efi-aarch64 ovmf \
        systemd-boot

RUN addgroup --gid ${GID} docker
RUN useradd -d /home/${USER} -r -u ${UID} -g ${GID} ${USER}
RUN mkdir -p -m 0755 /home/${USER}
RUN chown ${USER} /home/${USER}

RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER ${USER}

# Define entry point
WORKDIR /src
