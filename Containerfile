FROM debian:bullseye-slim

# Sync to current release
RUN apt-get dist-upgrade \
    && apt-get clean all

# Install dependencies
RUN apt-get update \
    && apt-get install -y \
    build-essential \
    devscripts \
    fakeroot \
    sudo \
    wget \
    && apt-get clean all

# Create unprivileged user
ARG USER=builder
ARG GROUP=${USER}
ARG UID=1000
ARG GID=${UID}
ARG HOME=/home/${USER}
RUN groupadd --gid "${GID}" "${GROUP}" && \
    useradd --uid "${UID}" --gid "${GID}" --create-home "${USER}"

# Allow passwordless sudo privileges so packages can be installed
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to unprivileged user
USER "${USER}"

# Set working directory to user's home
WORKDIR "${HOME}"
