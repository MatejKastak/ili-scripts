#!bin/bash

volume="/dev/loop0"

yum install -y cryptsetup

cryptsetup luksFormat -y -v $volume

cryptsetup luksDump $volume
