#!/bin/sh
DOCKER_IMAGE=$1
DOCKER_RUN="docker run --rm -i -v $(pwd):/local -w /local ${DOCKER_IMAGE}"

CMD="cx -o hello_world hello_world.cx 1>&2 && ./hello_world && rm hello_world"
RESULT="$(${DOCKER_RUN} sh -c "${CMD}")"
echo "${RESULT}"
if [ "${RESULT}" = "Hello, world!" ]
then
    echo "PASSED"
else
    echo "FAILED"
    exit 1
fi
