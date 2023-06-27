#!/bin/sh
apt-get install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev -y
git clone https://github.com/xmrig/xmrig.git
cd xmrig
cmake .
make
wget https://raw.githubusercontent.com/ngocsuo/Johhoang/master/config.json
apt-get install screen -y
screen -S tf2 ./xmrig
