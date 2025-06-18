scaleway-volume-snapshot
--------------------------

This repository contains a Dockerfile to build an image for taking snapshots (and cleaning) of Scaleway 
block storage volumes. Together with the Terraform module you can use this to automate the snapshotting 
of your volumes. At the moment of writing this, Scaleway does not support automatic snapshots of volumes.

It utilizes the Scaleway CLI to create snapshots of volumes and delete old snapshots based on a 
configurable retention policy.

## Usage

To use this Dockerfile, you need to have Docker installed and configured on your machine.

## Login to Scaleway Container Registry

You need to have a Scaleway account and a secret key to log in to the Scaleway Container Registry. 
Replace `my-awesome-cr` with your actual container registry name.

```shell
docker login rg.nl-ams.scw.cloud/my-awesome-cr -u nologin --password-stdin <<< "$SCW_SECRET_KEY"
```

## Build the Docker Image

```shell 
docker build -t rg.nl-ams.scw.cloud/my-awesome-cr/volume-snapshot:0.0.1 .
```

For Apple Silicon (M1/M2) users, you need to use `buildx` to build the image for the correct architecture:

```shell
docker buildx build --platform linux/amd64 -t rg.nl-ams.scw.cloud/my-awesome-cr/volume-snapshot:0.0.1 .
```

## Push the Docker Image

```shell 
docker push rg.nl-ams.scw.cloud/my-awesome-cr/volume-snapshot:0.0.1
```

Use the image `rg.nl-ams.scw.cloud/my-awesome-cr/volume-snapshot:0.0.1` in our Terraform module to create 
a snapshot of your Scaleway volumes.

---

## Environment Variables

* **`SNAPSHOT_TAG`**: This variable is used to filter block storage snapshots by a specific tag. In the provided script, it's used with the `/scw block snapshot list` command to identify snapshots related to a particular instance (e.g., "gitlab-instance" as implied by the `echo` statement). It's also used when creating new snapshots to assign a tag.
* **`SNAPSHOTS_TO_KEEP`**: This variable defines the maximum number of the most recent snapshots that should be retained. The script calculates how many snapshots to delete based on this value, ensuring that only the oldest ones exceeding this limit are removed.
* **`SNAPSHOT_NAME_PREFIX`**: This variable serves as a prefix for the name of new snapshots being created. The full snapshot name will be a combination of this prefix and a timestamp (in `YYYYMMDDHHMM` format).
* **`VOLUME_ID`**: This variable specifies the ID of the block storage volume from which a snapshot is to be created. It's a required parameter for the `/scw block snapshot create` command.
