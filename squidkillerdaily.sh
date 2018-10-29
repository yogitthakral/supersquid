#!/bin/bash
docker kill $((docker ps -a |grep "supersquid_daily") | awk '{print $NF}')
docker rm $((docker ps -a |grep "supersquid_daily") | awk '{print $NF}')
