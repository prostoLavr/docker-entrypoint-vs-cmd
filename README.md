# Docker ENTRYPOINT vs CMD
## Checking docker image ENTRYPOINT and CMD instructions

```sh
docker inspect --format='ENTRYPOINT: {{json .Config.Entrypoint}}; CMD: {{json .Config.Cmd}}' <DOCKER_IMAGE>
```

## Signal catching
CMD handles signal correctly if ENTRYPOINT is empty (null) or ends with `exec "$@"`
View and run `check-pid-inheritance.sh` to be sure that exec shell command replaces current process and doesn't make new one.
View and run `check-cmd-sig-handling.sh` to be sure that CMD instructions also correct works with signals.

## Default behavior
Let's look at any popular docker images to find what's better to use
### Node.JS
Image: node:26-slim
ENTRYPOINT: ["docker-entrypoint.sh"]; CMD: ["node"]
ENTRYPOINT script content:
```sh
#!/bin/sh
set -e

# Run command with node if the first argument contains a "-" or is not a system command. The last
# part inside the "{}" is a workaround for the following bug in ash/dash:
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=874264
if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ] || { [ -f "${1}" ] && ! [ -x "${1}" ]; }; then
  set -- node "$@"
fi

exec "$@"
```
### Python
Image: python:3.14-slim
ENTRYPOINT: null; CMD: ["python3"]

### Nginx
Image: nginx:1.31.6
ENTRYPOINT: ["/docker-entrypoint.sh"]; CMD: ["nginx","-g","daemon off;"]

ENTRYPOINT content is too big to place it there.
But notice that it just setups envs and config files and ends with `exec "$@"`

## Conclusion
Use ENTRYPOINT to setup environment and make shortcuts for default CMD instructions
Use CMD to setup executable proccess
