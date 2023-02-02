
variable "cpu_number" {
  type    = string
  default = "2"
}


variable "iso_checksum" {
  type    = string
  default = "5922d88e2e5de002bc3af1c2ef2c21ee6fa61132c26d6b742e1ebc366bfbbe3d"
}

variable "iso_checksum_type" {
  type    = string
  default = "sha256"
}

variable "iso_name" {
  type    = string
  default = "ubuntu-20.04.1-legacy-server-arm64.iso"
}

variable "iso_path" {
  type    = string
  default = "../iso"
}

variable "iso_url" {
  type    = string
  default = "https://cdimage.ubuntu.com/ubuntu-legacy-server/releases/20.04/release/ubuntu-20.04.1-legacy-server-arm64.iso"
}

variable "memory_size" {
  type    = string
  default = "2048"
}

variable "packagename" {
  type    = string
  default = "ubuntu-20.04-arm64.virtualbox"
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

variable "headless" {
  type    = string
  default = "false"
}

variable "hostname" {
  type    = string
  default = "focal64"
}

variable "virtualbox_guest_os_type" {
  type    = string
  default = "Ubuntu_64"
}

variable "vm_name" {
  type    = string
  default = "ubuntu-20.04"
}

variable "update" {
  type    = string
  default = "true"
}

variable "disable_ipv6" {
  type    = string
  default = "true"
}

variable "http_proxy" {
  type    = string
  default = "${env("http_proxy")}"
}

variable "https_proxy" {
  type    = string
  default = "${env("https_proxy")}"
}

variable "no_proxy" {
  type    = string
  default = "${env("no_proxy")}"
}

source "virtualbox-iso" "ubuntu-2004" {
  boot_command            = ["<esc><esc><enter><wait>", "/install/vmlinuz noapic", " initrd=/install/initrd.gz", " auto=true", " priority=critical", " hostname=${var.hostname}", " passwd/user-fullname=${var.ssh_fullname}", " passwd/username=${var.ssh_username}", " passwd/user-password=${var.ssh_password}", " passwd/user-password-again=${var.ssh_password}", " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed}", " -- <enter>"]
  boot_wait               = "30s"
  communicator            = "ssh"
  cpus                    = "${var.cpu_number}"
  disk_size               = 32000
  http_directory          = "../../../http"
  iso_checksum            = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_urls                = ["${var.iso_path}/${var.iso_name}", "${var.iso_url}"]
  memory                  = "${var.memory_size}"
  shutdown_command        = "echo '${var.ssh_password}'|sudo -S shutdown -P now"
  ssh_handshake_attempts  = "3"
  ssh_password            = "${var.ssh_password}"
  ssh_port                = 22
  ssh_timeout             = "10m"
  ssh_username            = "${var.ssh_username}"
  virtualbox_version_file = ".vbox_version"
  headless                = "${var.headless}"
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  # hard_drive_interface    = "sata"
  vboxmanage              = [["modifyvm", "{{ .Name }}", "--audio", "none"]
                             , ["modifyvm", "{{ .Name }}", "--usb", "off"]
                             , ["modifyvm", "{{ .Name }}", "--vram", "12"]
                             , ["modifyvm", "{{ .Name }}", "--vrde", "off"]
                             , ["modifyvm", "{{ .Name }}", "--nictype1", "virtio"]
                             , ["modifyvm", "{{ .Name }}", "--memory", "${var.memory_size}"]
                             , ["modifyvm", "{{ .Name }}", "--cpus", "${var.cpu_number}"]
                             , ["modifyvm", "{{ .Name }}", "--firmware", "efi"]
                             , ["modifyvm", "{{ .Name }}", "--graphicscontroller", "vmsvga"]
                             , ["modifyvm", "{{ .Name }}", "--nested-hw-virt", "on"]
                             , ["modifyvm", "{{ .Name }}", "--clipboard-mode", "bidirectional"]
                             , ["modifyvm", "{{ .Name }}", "--tpm-type", "2.0"]
                             ]
  vm_name                 = "${var.vm_name}"
  guest_os_type           = "${var.virtualbox_guest_os_type}"
  headless                = true

}

# ["modifyvm", "{{ .Name }}", "--tpm-type", "host"]



build {
  sources = ["source.virtualbox-iso.ubuntu-2004"]

  provisioner "shell" {
    environment_vars  = ["DEBIAN_FRONTEND=noninteractive", "UPDATE=${var.update}", "DISABLE_IPV6=${var.disable_ipv6}", "SSH_USERNAME=${var.ssh_username}", "SSH_PASSWORD=${var.ssh_password}", "http_proxy=${var.http_proxy}", "https_proxy=${var.https_proxy}", "no_proxy=${var.no_proxy}"]
    execute_command   = "echo '${var.ssh_password}' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    expect_disconnect = true
    scripts           = ["../../../scripts/init.sh", "../../../scripts/vagrant.sh", "../../../scripts/motd.sh", "../../../scripts/cleanup.sh"]
  }

  post-processor "vagrant" {
    keep_input_artifact  = false
    compression_level = "9"
    output            = "./output/tn-ubuntu2004.{{ .Provider }}.box"
  }
}
