#!/bin/bash
#Set new password

PASSWORD="asdf"

echo -e "$PASSWORD\n$PASSWORD\n" | passwd
