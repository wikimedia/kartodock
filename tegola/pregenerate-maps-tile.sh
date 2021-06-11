#!/bin/sh
if [ -z "$TEGOLA_BROKER_URL" ]
then
    echo "TEGOLA_BROKER_URL env var is not set"
    exit 1
fi
if [ -z "$TEGOLA_QUEUE_NAME" ]
then
    echo "TEGOLA_QUEUE_NAME env var is not set"
    exit 1
fi
if [ -z "$TEGOLA_PATH" ]
then
    echo "TEGOLA_PATH env var is not set"
    exit 1
fi
if [ -z "$TEGOLA_CONFIG_PATH" ]
then
    echo "TEGOLA_CONFIG_PATH env var is not set"
    exit 1
fi
TMP_DIR=$(mktemp -d /tmp/tegola-XXXXXXXXXX)
TILELIST_PATH=${TEGOLA_TILELIST_DIR:-$TMP_DIR}/tilelist.txt
BATCH_SIZE=${TEGOLA_PREGENERATION_BATCH_SIZE:-1000}
DEQUEUE_TIMEOUT=${TEGOLA_PREGENERATION_DEQUEUE_TIMEOUT:-60}
set -x
while true;
do
    # Dequeue a batch of messages from the queue and store them in tilelist
    poppy --broker-url "$TEGOLA_BROKER_URL" \
          --queue-name "$TEGOLA_QUEUE_NAME" \
          dequeue --batch "$BATCH_SIZE" --exit-on-empty True --dequeue-raise-on-empty True --blocking-dequeue-timeout "$DEQUEUE_TIMEOUT" > "$TILELIST_PATH"
    status=$?
    # Pregenerate tiles that exist in tilelist
    $TEGOLA_PATH --config "$TEGOLA_CONFIG_PATH" cache seed tile-list "$TILELIST_PATH"
    if [ $status -eq 100 ]  # Queue is empty
    then
        exit 0
    elif [ $status -gt 0 ]  # Something went wrong
    then
        exit 1
    fi
done
set +x
