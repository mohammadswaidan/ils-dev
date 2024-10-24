#!/bin/bash

# Outer loop: count from 1 to 100
for ((i=1; i<=100; i++)); do
    echo "Outer loop count: $i"
    # Inner loop: count from 1 to 100
    for ((j=1; j<=100; j++)); do
        echo "Inner loop count: $j"
	sleep 2
    done
done

