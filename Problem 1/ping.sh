#!/bin/bash
#   This script pings the second node from the first node
#   First >>chmod 755 ping.sh 
#   then >>./ping.sh <first_node> <second_node>
declare -A nodes=( ["node1"]="172.0.0.2" ["node2"]="172.0.0.3" ["node3"]="10.10.0.2" ["node4"]="10.10.0.3" ["router"]="10.10.0.1")
if [ "$2" == "router" ];then
    if [ "$1" == "node1" ] || [ "$1" == "node2" ]; then
        ip netns exec $1 ping "172.0.0.1"
    else [ "$1" == "node3" ] || [ "$1" == "node4" ]
        ip netns exec $1 ping "10.10.0.1"
    fi
else [ "$2" == "node1" ] || [ "$2" == "node2" ] || [ "$2" == "node3" ] || [ "$2" == "node4" ]
    ip netns exec $1 ping ${nodes[$2]}
fi