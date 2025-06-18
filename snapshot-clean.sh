#!/bin/bash

SNAPSHOT_INFO=$(/scw block snapshot list "tags.0=$SNAPSHOT_TAG" -o json | \
  jq -c '[.[] | {id: .id, created_at: .created_at}] | sort_by(.created_at)')

TOTAL_SNAPSHOTS=$(echo "$SNAPSHOT_INFO" | jq length)

echo "Total 'gitlab-instance' snapshots found: $TOTAL_SNAPSHOTS"

if [ "$TOTAL_SNAPSHOTS" -gt "$SNAPSHOTS_TO_KEEP" ]; then
    NUM_TO_DELETE=$((TOTAL_SNAPSHOTS - SNAPSHOTS_TO_KEEP))

    echo "Number of snapshots to delete: $NUM_TO_DELETE"

    SNAPSHOT_IDS_TO_DELETE=$(echo "$SNAPSHOT_INFO" | jq -r ".[0:$NUM_TO_DELETE] | .[] | .id")

    for SNAPSHOT_ID in $SNAPSHOT_IDS_TO_DELETE; do
        echo "Deleting snapshot: $SNAPSHOT_ID"
        /scw block snapshot delete "$SNAPSHOT_ID"
        if [ $? -eq 0 ]; then
            echo "Snapshot $SNAPSHOT_ID successfully deleted."
        else
            echo "Error deleting snapshot $SNAPSHOT_ID."
        fi
    done
else
    echo "Not enough snapshots to delete. Keeping all $TOTAL_SNAPSHOTS snapshots."
fi
