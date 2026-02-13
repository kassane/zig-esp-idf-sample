ARG DOCKER_TAG=latest
FROM espressif/idf:${DOCKER_TAG}

ARG DEBIAN_FRONTEND=nointeractive
ARG CONTAINER_USER=esp
ARG USER_UID=1050
ARG USER_GID=$USER_UID

RUN apt-get update \
  && apt install -y -q \
  cmake \
  git \
  libglib2.0-0 \
  libnuma1 \
  libpixman-1-0 \
  && rm -rf /var/lib/apt/lists/*

# QEMU
ENV QEMU_REL=esp_develop_9.0.0_20240606
ENV QEMU_SHA256=071d117c44a6e9a1bc8664ab63b592d3e17ceb779119dcb46c59571a4a7a88c9
ENV QEMU_DIST=qemu-xtensa-softmmu-${QEMU_REL}-x86_64-linux-gnu.tar.xz
ENV QEMU_URL=https://github.com/espressif/qemu/releases/download/esp-develop-9.0.0-20240606/${QEMU_DIST}

# Zig v0.16.0 - xtensa
ENV ZIG_REL=zig-relsafe-x86_64-linux-musl-baseline
ENV ZIG_SHA256=123cfce4aa80db09cf07ca8895a6f2302bf0f265f75eff7969c9cbf3863e3437
ENV ZIG_DIST=${ZIG_REL}.tar.xz
ENV ZIG_URL=https://github.com/kassane/zig-espressif-bootstrap/releases/download/0.16.0-xtensa-dev/${ZIG_DIST}

# ZLS v0.16.0
ENV ZLS_REL=zls-x86_64-linux-musl-baseline
ENV ZLS_SHA256=13cc80fc80e5dec8b2424289a9fecfa9191014cdfa8c8273117d5e393f9ff122
ENV ZLS_DIST=${ZLS_REL}.tar.xz
ENV ZLS_URL=https://github.com/kassane/zig-espressif-bootstrap/releases/download/0.16.0-xtensa-dev/${ZLS_DIST}

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

RUN wget --no-verbose ${ZLS_URL} \
  && echo "${ZLS_SHA256} *${ZLS_DIST}" | sha256sum --check --strict - \
  && mkdir -p /opt/zls \
  && tar -xf $ZLS_DIST -C /opt/zls \
  && rm ${ZLS_DIST}

ENV PATH=/opt/qemu/bin:/opt/${ZIG_REL}:/opt/zls:${PATH}

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
