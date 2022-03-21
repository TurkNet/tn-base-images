#!/bin/bash -eux

# Add vagrant user to sudoers.
echo "Adding vagrant user to sudoers..."
echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/99_vagrant;
chmod 440 /etc/sudoers.d/99_vagrant;
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers



# Disable daily apt unattended updates.
echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic
