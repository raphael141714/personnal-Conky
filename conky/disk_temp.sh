#!/bin/sh
hddtemp /dev/sda|awk '{print $NF}'| tr -d '°C'
