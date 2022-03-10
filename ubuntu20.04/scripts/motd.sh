#!/bin/sh -eux

motd='
This system is built by the TurkNetDevOps
More information can be found at https://github.com/orgs/TurkNet/teams/devops'

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