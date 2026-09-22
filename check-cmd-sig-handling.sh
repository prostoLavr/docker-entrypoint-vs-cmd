#!/usr/bin/bash
IMAGE_NAME=docker-entrypoint-vs-cmd-python
CONTAINER_NAME=docker-entrypoint-vs-cmd-python-1
docker build -t ${IMAGE_NAME} .
docker run -d --rm \
  --name ${CONTAINER_NAME} \
  ${IMAGE_NAME}
echo "Container started"
sleep 1
echo "Send signals"
docker kill --signal=15 ${CONTAINER_NAME}
docker kill --signal=2 ${CONTAINER_NAME}
echo "Signals sended"
sleep 1
echo "Logs:"
docker logs ${CONTAINER_NAME}
echo "Stopping container..."
docker stop ${CONTAINER_NAME}
