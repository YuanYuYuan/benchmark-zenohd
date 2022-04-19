#!/usr/bin/env bash

for commit in $(cat selected-commits.txt); do
    if [ ! -d zn-commits/$commit ]; then
        git -C zenoh worktree add -f ../zn-commits/$commit $commit
    fi
done
