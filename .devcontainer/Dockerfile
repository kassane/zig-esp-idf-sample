FROM espressif/idf

ARG DEBIAN_FRONTEND=nointeractive
ARG CONTAINER_USER=esp
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update \
  && apt install -y -q \
  cmake \
  git \
  hwdata \
  libglib2.0-0 \
  libnuma1 \
  libpixman-1-0 \
  linux-tools-virtual \
  && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/local/bin/usbip usbip `ls /usr/lib/linux-tools/*/usbip | tail -n1` 20

# QEMU
ENV QEMU_REL=xtensa-softmmu-esp_develop_8.2.0_20240122-x86_64-linux-gnu
ENV QEMU_SHA256=e7c72ef5705ad1444d391711088c8717fc89f42e9bf6d1487f9c2a326b8cfa83
ENV QEMU_DIST=qemu-${QEMU_REL}.tar.xz
ENV QEMU_URL=https://github.com/espressif/qemu/releases/download/esp-develop-8.2.0-20240122/${QEMU_DIST}

# Zig v0.14.0 - xtensa
ENV ZIG_REL=zig-relsafe-espressif-x86_64-linux-musl-baseline
ENV ZIG_SHA256=0b70670e28f9568bb8112c59572e6790d897ba17ed50ac15b3c3b42330a3c2d7
ENV ZIG_DIST=${ZIG_REL}.tar.xz
ENV ZIG_URL=https://github.com/kassane/zig-espressif-bootstrap/releases/download/0.14.0-xtensa-dev/${ZIG_DIST}

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN wget --no-verbose ${QEMU_URL} \
  && echo "${QEMU_SHA256} *${QEMU_DIST}" | sha256sum --check --strict - \
  && tar -xf $QEMU_DIST -C /opt \
  && rm ${QEMU_DIST}

RUN wget --no-verbose ${ZIG_URL} \
  && echo "${ZIG_SHA256} *${ZIG_DIST}" | sha256sum --check --strict - \
  && tar -xf $ZIG_DIST -C /opt \
  && rm ${ZIG_DIST}

ENV PATH=/opt/qemu/bin:/opt/${ZIG_REL}:${PATH}

RUN groupadd --gid $USER_GID $CONTAINER_USER \
  && adduser --uid $USER_UID --gid $USER_GID --disabled-password --gecos "" ${CONTAINER_USER} \
  && usermod -a -G root $CONTAINER_USER && usermod -a -G dialout $CONTAINER_USER

RUN chmod -R 775 /opt/esp/python_env/

USER ${CONTAINER_USER}
ENV USER=${CONTAINER_USER}
WORKDIR /home/${CONTAINER_USER}

RUN echo "source /opt/esp/idf/export.sh > /dev/null 2>&1" >> ~/.bashrc

ENTRYPOINT [ "/opt/esp/entrypoint.sh" ]

CMD ["/bin/bash", "-c"]
