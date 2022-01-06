FROM archlinux:latest

ARG UID=1001
ARG GID=1001
ARG USER=calaos

RUN pacman-key --init
RUN pacman-key --populate archlinux
RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm git archiso
RUN pacman -S --noconfirm fakeroot base-devel sudo nano mtools syslinux

# Create user and its home
#RUN addgroup --gid ${GID} docker
RUN groupadd -g ${GID} docker
RUN useradd -d /home/${USER} -r -u ${UID} -g ${GID} ${USER}
RUN usermod -G wheel ${USER}
RUN mkdir -p -m 0755 /home/${USER}
RUN chown ${USER} /home/${USER}
RUN echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ${USER}

COPY create_hddimg.sh /usr/sbin/create_hddimg.sh

# Define entry point
WORKDIR /src
