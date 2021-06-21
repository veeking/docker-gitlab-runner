FROM ubuntu:18.04
MAINTAINER veeking "veekingsen@163.com"

ARG NODE_VERSION=16
ARG NODE_URL=https://deb.nodesource.com/setup_${NODE_VERSION}.x
ARG GITLAB_RUNNER_URL=https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
ARG DUMB_INIT_URL=https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 
ARG DOCKER_MACHINE_URL=https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-Linux-x86_64

RUN apt-get update && \
    apt-get install -y \
    ca-certificates \
    openssh-server \
    curl \
    git \
    gnupg \
    gcc \
    g++ \
    make \
 && curl -sL ${NODE_URL} | bash - \
 && apt-get install -y nodejs \
 && rm -rf /var/lib/apt/lists/* \
 && npm install -g yarn \
 && curl -sL -o /usr/local/bin/gitlab-runner ${GITLAB_RUNNER_URL} \
 && chmod +x /usr/local/bin/gitlab-runner \
 && curl -sL -o /usr/local/bin/docker-machine ${DOCKER_MACHINE_URL} \
 && chmod +x /usr/local/bin/docker-machine \
 && curl -sL -o /usr/bin/dumb-init ${DUMB_INIT_URL} \
 && chmod +x /usr/bin/dumb-init
# Copy entry script into image container folder
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create empty config folder and file
# RUN mkdir -p /etc/gitlab-runner \ 
# && chmod 0700 /etc/gitlab-runner
# RUN touch /etc/gitlab-runner/config.toml \
# && chmod 0600 /etc/gitlab-runner/config.toml

# Exit process processing before starting
STOPSIGNAL SIGQUIT
# Set mount data directory for gitlab-runner
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]

CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint.sh"]