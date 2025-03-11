#!/bin/bash

for x in {0..255}; do
    # Ping the server with a timeout of 1 second and send 1 packet
    if ping -c 1 -W 1 172.16.17.$x &> /dev/null; then
        echo "Server 172.16.17.$x is up and running"
    else
        echo "Server 172.16.17.$x is unreachable"
    fi
done