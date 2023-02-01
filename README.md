# TurkNet Base Images

## TurkNet-DevOps Vagrant Box Packer Builds

Vagrant Cloud images (https://app.vagrantup.com/turknet-devops)

All of these boxes are available as public, free Vagrant boxes and can be used with the command:

```bash
vagrant init turknet-devops/[box name here]
vagrant up
```

Vagrant Plugin List:
<https://vagrant-lists.github.io>

## Usage

### Packer

- Parallels Builder (from an ISO) [Home Page](https://www.packer.io/plugins/builders/parallels/iso)

Make sure all the required software (listed above) is installed, then cd into one of the box directories and run:

Build Command:

```bash
packer build ./packer.parallels.json
```

Packer Plugin Install:

<https://www.packer.io/docs/commands/plugins/install>

<https://www.packer.io/docs/plugins#create-a-required_plugins-block>


## Testing built boxes

There's an included Vagrantfile that allows quick testing of the built Vagrant boxes. From the same box directory, run the following command after building the box:

```bash
  vagrant up
```

Test that the box works correctly, then tear it down with:

```bash
  vagrant destroy -f
```

## Checksum SHA256

```bash
  shasum -a 256 ubuntu-20.04-arm64.parallels.box
```

### Error
1. "Build 'ubuntu-2004' errored after 41 milliseconds 278 microseconds: Failed creating Parallels driver: Parallels Virtualization SDK is not installed"

```bash
sudo ln -s /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/prlsdkapi.pth /Applications/Xcode.app/Contents/Developer/Library/Frameworks/Python3.framework/Versions/3.9/lib/python3.9/site-packages/prlsdkapi.pth
```

## Requirements

The following software must be installed/present on your local machine before you can use Packer to build any of these Vagrant boxes:

- [Packer](http://www.packer.io/)
- [Vagrant](http://vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- [Parallels Desktop](https://www.parallels.com/products/desktop/) also requires [Parallels Virtualization SDK](https://www.parallels.com/products/desktop/download/)
- [VMWare Fusion](https://www.vmware.com/products/fusion.html)
- [SHASUM](https://www.commandlinux.com/man-page/man1/shasum.1.html)

## References

- [geerlingguy](https://github.com/geerlingguy/packer-boxes)
- [Chef/Bento](https://github.com/chef/bento)
