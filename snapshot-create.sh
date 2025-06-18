#!/bin/bash

SNAPSHOT_NAME="${SNAPSHOT_NAME_PREFIX}-$(date +%Y%m%d%H%M)"

/scw block snapshot create \
  volume-id="$VOLUME_ID" \
  name="$SNAPSHOT_NAME" \
  tags.0="$SNAPSHOT_TAG" \
  --debug
