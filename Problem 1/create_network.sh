#!/usr/bin/env bash

    # Instructions to run this script:
    #     chmod 755 ./create_network.sh
    #     sudo ./create_network.sh
    
    # This file creates 5 nodes each in their own network namespace,
    # assigns static ips to them which are on 2 subnets,
    # then we set up default gateways and veth pairs on each namespace and add two bridges 
    # for them to communicate.


# Create namespaces
ip netns add node1  #172.0.0.2/24
ip netns add node2  #172.0.0.3/24
ip netns add node3  #10.10.0.2/24
ip netns add node4  #10.10.0.3/24
ip netns add router #172.0.0.1/24 , 10.10.0.1/24

# setup veth pairs on each node and assign ip's and set the default gateway
# also bring up the links
function node_setup {
    ip link add $2 type veth peer name $3
    ip link set $2 up
    ip link set $3 netns $1
    ip netns exec $1 ip link set lo up
    ip netns exec $1 ip link set $3 up
    ip netns exec $1 ip addr add $4 dev $3
    ip netns exec $1 ip route add default via $5
}
# Node 1 setup
node_setup node1 veth1 ceth1 172.0.0.2/24 172.0.0.1

# Node 2 setup
node_setup node2 veth2 ceth2 172.0.0.3/24 172.0.0.1

# Node 3 setup
node_setup node3 veth3 ceth3 10.10.0.2/24 10.10.0.1

# Node 4 setup
node_setup node4 veth4 ceth4 10.10.0.3/24 10.10.0.1

# Router setup
ip link add veth00 type veth peer name ceth00
ip link add veth01 type veth peer name ceth01
ip link set veth00 up
ip link set ceth00 netns router
ip link set veth01 up
ip link set ceth01 netns router
ip netns exec router ip link set lo up
ip netns exec router ip link set ceth00 up
ip netns exec router ip addr add 172.0.0.1/24 dev ceth00
ip netns exec router ip link set ceth01 up
ip netns exec router ip addr add 10.10.0.1/24 dev ceth01


# Bridge setup
function bridge_setup {
    ip link add $1 type bridge
    ip link set $1 up
    ip link set $2 master $1
    ip link set $3 master $1
    ip link set $4 master $1
    ip addr add $5 dev $1
    # Let bridges forward packets, otherwise they will drop them by default
    iptables -A FORWARD -i $1 -j ACCEPT
}
bridge_setup br1 veth1 veth2 veth00 172.0.0.1/24
bridge_setup br2 veth3 veth4 veth01 10.10.0.1/24




