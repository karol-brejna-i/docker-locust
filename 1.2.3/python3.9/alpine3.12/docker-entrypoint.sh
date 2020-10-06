#!/bin/sh
#   Copyright 2019 Karol Brejna
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
set -e
LOCUST_MODE=${LOCUST_MODE:-standalone}
LOCUST_MASTER_BIND_PORT=${LOCUST_MASTER_BIND_PORT:-5557}
LOCUST_FILE=${LOCUST_FILE:-locustfile.py}

if [ -z ${ATTACKED_HOST+x} ] ; then
    echo "You need to set the URL of the host to be tested (ATTACKED_HOST)."
    exit 1
fi

LOCUST_OPTS="-f ${LOCUST_FILE} --host=${ATTACKED_HOST} $LOCUST_OPTS"

case $(echo "${LOCUST_MODE}" | tr '[:lower:]' '[:upper:]') in
"MASTER")
    LOCUST_OPTS="--master --master-bind-port=${LOCUST_MASTER_BIND_PORT} $LOCUST_OPTS"
    ;;

"WORKER")
    LOCUST_OPTS="--worker --master-host=${LOCUST_MASTER_HOST} --master-port=${LOCUST_MASTER_BIND_PORT} $LOCUST_OPTS"
    if [ -z ${LOCUST_MASTER_HOST+x} ] ; then
        echo "You need to set LOCUST_MASTER_HOST."
        exit 1
    fi
    ;;
esac

cd /locust
locust ${LOCUST_OPTS}
