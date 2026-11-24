#!/bin/bash

verifica_ip() {
    local ip="$1"
    local a b c d extra

    if [[ ! "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 1
    fi

    IFS=. read -r a b c d extra <<< "$ip"

    for octet in "$a" "$b" "$c" "$d"; do
        if (( 10#$octet > 255 )); then
            return 1
        fi
    done

    return 0
}

while read -r ip hostname rest; do
    [[ -z "$ip" || "$ip" == \#* ]] && continue

    if [[ "$ip" == *:* ]]; then
        continue
    fi

    if verifica_ip "$ip"; then
        echo "IP valid: $ip - Host: $hostname"
    else
        echo "IP invalid: $ip - Host: $hostname"
    fi
done < /etc/hosts
