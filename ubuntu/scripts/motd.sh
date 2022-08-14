#!/bin/sh -eux

motd="
 _____           _    _   _      _   
|_   _|   _ _ __| | _| \ | | ___| |_ 
  | || | | | '__| |/ /  \| |/ _ \ __|
  | || |_| | |  |   <| |\  |  __/ |_ 
  |_| \__,_|_|  |_|\_\_| \_|\___|\__|

This system is built by the TurkNet
More information can be found at https://github.com/orgs/TurkNet/"

if [ -d /etc/update-motd.d ]; then
    MOTD_CONFIG='/etc/update-motd.d/99-turknetdevops'

    cat >> "$MOTD_CONFIG" <<motd
#!/bin/sh

cat <<'EOF'
$motd
EOF
motd

    chmod 0755 "$MOTD_CONFIG"
else
    echo "$motd" >> /etc/motd
fi
