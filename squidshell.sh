#!/bin/bash


hostvariable=$2
terminateFlag=$3

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Terminate Flag is $terminateFlag"
echo "Your Host Entries are :-"
echo "$hostvariable"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"




#hostvariable="127.0.0.1=www.google.com
#127.0.0.1=www.yahoo.com"

namespace=$1

if [[ ! $hostvariable ]]; then
     echo "No host defined , Please define host in this format 1.1.1.1=www.abc.com in a multiline input"
exit 1;
fi



hostcommand=""
while read -r line ;
do
#echo $line
IFS='=' read -r -a array <<< "$line"
#echo ${array[0]}
#echo ${array[1]}
hostcommand="$hostcommand  --add-host ${array[1]}:${array[0]}"

done <<<"$hostvariable"


#echo $hostcommand


if [[ $terminateFlag == "Daily" ]];then
namespace="${namespace}_supersquid_daily"
#echo "docker run -itd -P --name ${namespace}_supersquid_daily $hostcommand yogitthakral/supersquid"
docker run -itd -P --name ${namespace}_supersquid_daily $hostcommand yogitthakral/supersquid >/dev/null
else
namespace="${namespace}_supersquid_weekly"
docker run -itd -P --name ${namespace}_supersquid_weekly $hostcommand yogitthakral/supersquid >/dev/null
fi


if [[ $? -eq 0 ]]; then
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Proxy Ip is :- 172.16.3.238"
sleep 1
echo "proxy Port is :-" $((( docker ps|grep $namespace) | awk '{print $13}' )|grep -Po '0.0.0.0:\K[^-]*')
echo "Your proxy namespace is ${namespace}"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

fi

#echo $(((docker ps|grep $namespace'_supersquid') | awk '{print $10}')|grep -Po '0.0.0.0:\K[^-]*')
