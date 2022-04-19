#!/usr/bin/env bash


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

cleanup

exp_dir="./exp"
n_exp=2
duration="10s"

sub="./zenoh-pico/build/examples/zn_sub_thr"

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

        nice -n -10 $zenohd &
        sleep 2
        nice -n -10 stdbuf -oL $sub > $log_file &
        sleep 2
        timeout $duration nice -n -10 $pub 8 --print > /dev/null
        cleanup
        sleep 1
    done
done

echo 'Finished'
