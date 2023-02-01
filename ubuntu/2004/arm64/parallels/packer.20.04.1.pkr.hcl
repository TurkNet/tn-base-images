
variable "cpu_number" {
  type    = string
  default = "4"
}

variable "hostname" {
  type    = string
  default = "ubuntu-2004"
}

variable "iso_checksum" {
  type    = string
  default = "d6fea1f11b4d23b481a48198f51d9b08258a36f6024cb5cec447fe78379959ce"
}

variable "iso_checksum_type" {
  type    = string
  default = "sha256"
}

variable "iso_name" {
  type    = string
  default = "ubuntu-20.04.3-live-server-arm64.iso"
}

variable "iso_path" {
  type    = string
  default = "../iso"
}

variable "iso_url" {
  type    = string
  default = "https://old-releases.ubuntu.com/releases/20.04.1/ubuntu-20.04.3-live-server-arm64.iso"
}

variable "memory_size" {
  type    = string
  default = "6144"
}

variable "packagename" {
  type    = string
  default = "ubuntu-20.04-arm64.parallels"
}

variable "preseed" {
  type    = string
  default = "preseed.cfg"
}

variable "ssh_fullname" {
  type    = string
  default = "vagrant"
}

variable "ssh_password" {
  type    = string
  default = "vagrant"
}

variable "ssh_username" {
  type    = string
  default = "vagrant"
}

source "parallels-iso" "ubuntu-2004" {
  boot_command           = ["<esc>", "linux /casper/vmlinuz", " quiet", " autoinstall", " ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'", "<enter>", "initrd /casper/initrd<enter>", "boot<enter>"]
  boot_wait              = "5s"
  communicator           = "ssh"
  cpus                   = "${var.cpu_number}"
  disk_size              = 20000
  guest_os_type          = "ubuntu"
  http_directory         = "../../../http"
  iso_checksum           = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_urls               = ["${var.iso_path}/${var.iso_name}", "${var.iso_url}"]
  memory                 = "${var.memory_size}"
  parallels_tools_flavor = "lin-arm"
  prlctl_version_file    = ".prlctl_version"
  shutdown_command       = "echo '${var.ssh_password}'|sudo -S shutdown -P now"
  ssh_handshake_attempts = "3"
  ssh_password           = "${var.ssh_password}"
  ssh_port               = 22
  ssh_timeout            = "20m"
  ssh_username           = "${var.ssh_username}"
  vm_name                = "${var.packagename}"
}

build {
  sources = ["source.parallels-iso.ubuntu-2004"]

  provisioner "shell" {
    execute_command   = "echo '${var.ssh_password}' | {{ .Vars }} sudo -S -E bash -eux '{{ .Path }}'"
    expect_disconnect = true
    scripts           = ["../../../scripts/init.sh", "../../../scripts/vagrant.sh", "../../../scripts/parallels.sh", "../../../scripts/cleanup.sh"]
  }

  post-processor "vagrant" {
    compression_level = "9"
    output            = "./output/${var.packagename}.box"
  }
}
