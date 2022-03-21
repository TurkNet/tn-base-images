# Usage

## Ubuntu Images

Ubuntu 20.04 LTS (Focal Fossa)

<https://old-releases.ubuntu.com/releases/20.04.1/>

Ubuntu-20.04.1-live-server-arm64
d6fea1f11b4d23b481a48198f51d9b08258a36f6024cb5cec447fe78379959ce

<https://old-releases.ubuntu.com/releases/20.04.1/ubuntu-20.04.1-live-server-arm64.iso>

Ubuntu 20.04 LTS (Focal Fossa) - SHA256SUMS

<https://old-releases.ubuntu.com/releases/20.04.1/SHA256SUMS>

## Packer Build

Packer Build command

```bash
packer build .\packer.parallels.json
```

Packer Build and Upload VagrantCloud

```bash
packer build -var-file=./variables.json ./packer.parallels.json
```

## Vagrant

Vagrant Command

Vagrant Up and Running

```bash
vagrant up
```

Vagrant Down and Delete

```bash
vagrant destroy
```

Fix EFI boot error

<https://forum.parallels.com/threads/official-ubuntu-20-04-live-server-does-not-boot.356891/>

Added package to http/user-data

linux-image-5.13.0-25-generic
