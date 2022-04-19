#!/usr/bin/env bash

if [ -f zenoh-pico/build/examples/zn_sub_thr ]; then
    echo 'zenoh-pico had already been compiled. Skip it.'
    exit
fi
cd zenoh-pico
make
sudo make install
