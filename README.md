# docker-gitlab-runner
Docker is based on Ubuntu for gitlab-runner and node.

## Use
- 1. Build your image container
 - `docker build -t containerName .`
- 2. Start and run container
 - `docker run -d --name=runtime-name --restart=always -e REGISTRATION_TOKEN=token -e CI_SERVER_URL=url -e RUNNER_EXECUTOR=shell -e RUNNER_SHELL=bash containerName:latest`
- 3. Register gitlab-runner
 - `docker exec -it [containerId] gitlab-runner register`
- 4. Configuring runner to finish!

## Reference
- gitlab-runner: https://gitlab.com/gitlab-org/gitlab-runner
- gitlan-runner configuration: https://docs.gitlab.com/runner/configuration/advanced-configuration.html