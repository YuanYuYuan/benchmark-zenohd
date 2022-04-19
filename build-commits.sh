#!/usr/bin/env bash

dir="$(realpath ./zn-commits)"
for commit in $(ls zn-commits); do
    cd $dir/$commit
    # cargo clean
    cargo build --release &
    cargo build --release --example=z_pub_thr &
done

wait
echo "Done"
