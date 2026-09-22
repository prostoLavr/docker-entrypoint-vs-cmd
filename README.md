# Docker ENTRYPOINT vs CMD
## Checking docker image ENTRYPOINT and CMD instructions

```sh
docker inspect --format='ENTRYPOINT: {{json .Config.Entrypoint}}; CMD: {{json .Config.Cmd}}' <DOCKER_IMAGE>
```

## Signal catching
CMD handles signals correctly if ENTRYPOINT is empty (null) or ends with `exec "$@"`

View and run `check-pid-inheritance.sh` to be sure that the `exec` shell command replaces the current process and doesn't create a new one.

View and run `check-cmd-sig-handling.sh` to be sure that CMD instructions also work correctly with signals.

## Default behavior
Let's look at some popular docker images to see what's better to use
### Node.JS
Image: node:26-slim

ENTRYPOINT: ["docker-entrypoint.sh"]

CMD: ["node"]

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

ENTRYPOINT: null

CMD: ["python3"]

### Nginx
Image: nginx:1.31.6

ENTRYPOINT: ["/docker-entrypoint.sh"]

CMD: ["nginx","-g","daemon off;"]

ENTRYPOINT script content is too ong to place it here.
But notice that it just setups env vars, config files and also ends with `exec "$@"`

## Conclusion

Use ENTRYPOINT to set up environment and make shortcuts for default CMD instructions

Use CMD to set up the executable proccess

Why? I think these rules make your containers more friendly and standard-styled. Every developer knows how the containers shown above work and keeping the same behavior keeps their knowledge relevant. Instructions as `python3 main.py` in ENTRYPOINT are unexpected by most devs. Also set up environment in ENTRYPOINT to prevent situations where replacing CMD with any script removes expected environment variables.
