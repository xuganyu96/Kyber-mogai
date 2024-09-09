#!/bin/bash

make speed

make -C kyber/ref speed
./kyber/ref/test/test_speed512
./kyber/ref/test/test_speed768
./kyber/ref/test/test_speed1024
