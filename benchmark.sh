#!/usr/bin/env bash

if [ ! $(nproc) -ge 6 ]; then
    echo 'This experiment requires at least 6 processors to run.'
    exit
fi

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


trap ctrl_c INT

function ctrl_c() {
    cleanup
    exit
}

function cleanup() {
    pkill zenohd
    pkill zn_sub_thr
    pkill z_pub_thr
}


exp_dir="./exp"

# Some parameters to adjust
n_exp=4          # total number of experiments
duration="30s"   # testing time of each experiments
payload_size=8   # payload size used in pub

sub="./zenoh-pico/build/examples/zn_sub_thr"

cleanup
for i in $(seq 1 $n_exp); do

    out_dir="${exp_dir}/${i}"
    mkdir -p $out_dir

    for commit in $(ls zn-commits); do
        log_file=${out_dir}/${commit}.txt
        if [ -f $log_file ]; then
            rm $log_file
        fi

        zenohd="./zn-commits/${commit}/target/release/zenohd"
        pub="./zn-commits/${commit}/target/release/examples/z_pub_thr"

        nice -n -10 taskset -c 0,1 $zenohd &
        sleep 2
        nice -n -10 taskset -c 2,3 stdbuf -oL $sub > $log_file &
        sleep 2
        timeout $duration nice -n -10 taskset -c 4,5 $pub $payload_size --print > /dev/null
        cleanup
        sleep 1
    done
done

echo 'Finished'
