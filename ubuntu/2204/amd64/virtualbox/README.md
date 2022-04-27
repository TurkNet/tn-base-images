# VirtualBox Installation

[VirtualBox](https://www.vagrantup.com/docs/providers/virtualbox)

```bash
packer build -var 'version=<version>' -var 'cloud_token=<token>' packer.virtualbox.json
```