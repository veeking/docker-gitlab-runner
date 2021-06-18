FROM ubuntu:18.04
MAINTAINER veeking "veekingsen@163.com"

ARG NODE_VERSION=16
ARG NODE_URL=https://deb.nodesource.com/setup_${NODE_VERSION}.x
ARG GITLAB_RUNNER_URL=https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64

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
 && chmod +x /usr/local/bin/gitlab-runner
# Copy entry script into image container folder
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create empty config folder and file
RUN mkdir -p /etc/gitlab-runner \ 
&& chmod 0700 /etc/gitlab-runner
RUN touch /etc/gitlab-runner/config.toml \
&& chmod 0600 /etc/gitlab-runner/config.toml

# Set mount data directory for gitlab-runner
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]

CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
ENTRYPOINT ["/entrypoint.sh"]