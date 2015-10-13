#!/bin/bash

TMP_FILE="/tmp/$(basename $0).$$.tmp"
BEGIN='^# @@@BEGIN$'
END='^# @@@END$'
FILE="/opt/zookeeper/conf/zoo.cfg"

# Prerequisites
if [ -z ${ZOO_ID} ] ; then
  echo 'No ID specified, please specify one between 1 and 255'
  exit -1
fi
if [ -z ${ZOO_SRV} ] ; then
  echo 'No server list specified, please specify comma-separated list of servers'
  exit -1
fi

# Configure cluster's server list
IFS=',' read -a servers <<< "${ZOO_SRV}" 
for i in "${!servers[@]}"; do
     server="${servers[${i}]}"
     index=$((${i}+1))
     echo server.${index}=${server}:2888:3888 >> ${TMP_FILE} 
done

sed -i -e "/$BEGIN/,/$END/{ /$BEGIN/{p; r ${TMP_FILE}
}; /$END/p; d }" ${FILE}

rm -f ${TMP_FILE}

# Configure myid
echo "${ZOO_ID}" > /var/lib/zookeeper/data/myid

# Start Zookeeper
/opt/zookeeper/bin/zkServer.sh start-foreground

