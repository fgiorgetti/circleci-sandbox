#!/bin/bash

OIFS=$IFS
IFS=,
if [ -z "${PORT_MAPPING}" ]; then
    echo "No port mapping provided"
    exit 1
fi

cat << EOF > /tmp/iptables.sh
iptables -t nat -F
EOF
chmod 0755 /tmp/iptables.sh

HOST_IP=$(grep host.docker.internal /etc/hosts | awk '{print $1}')

for port in $PORT_MAPPING; do
    while IFS=: read -r inport dest; do
        IFS=: read -r destaddr destport <<< "${dest}"
        [[ "${destaddr}" = "host.docker.internal" ]] && dest="${HOST_IP}:${destport}"
        cat << EOF >> /tmp/iptables.sh
iptables -t nat -I PREROUTING -p tcp --dport ${inport} -j DNAT --to ${dest}
iptables -t nat -I POSTROUTING -p tcp -d ${destaddr} --dport ${destport} -j MASQUERADE
EOF
    done <<< $port;
done

/tmp/iptables.sh
sleep infinity
