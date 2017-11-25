#!/bin/bash
if rpm -q sysstat &>/dev/null; then
    echo "sysstat is already installed."
else
    echo "sysstat is not installed!"
fi
