#!/bin/bash
docker kill $((docker ps -a |grep "supersquid_weekly") | awk '{print $NF}')
docker rm $((docker ps -a |grep "supersquid_weekly") | awk '{print $NF}')
