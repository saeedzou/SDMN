#!/usr/bin/env bash
'''
    Instructions to run this script:
        sudo ./create_network.sh
    
    This file creates 5 nodes each in their own network namespace,
    assigns static ips to them which are on 2 subnets,
    then we set up default gateways and veth pairs on each namespace and add two bridges 
    for them to communicate.

'''
# create namespaces
ip netns add node1  #172.0.0.2/24
ip netns add node2  #172.0.0.3/24
ip netns add node3  #10.10.0.2/24
ip netns add node4  #10.10.0.3/24
ip netns add router #172.0.0.1/24 , 10.10.0.1/24

# setup veth pairs on each node and assign ip's and set the default gateway
# also bring up the links
# Node 1 setup
ip link add veth1 type veth peer name ceth1
ip link set veth1 up
ip link set ceth1 netns node1
ip netns exec node1 ip link set lo up
ip netns exec node1 ip link set ceth1 up
ip netns exec node1 ip addr add 172.0.0.2/24 dev ceth1
ip netns exec node1 ip route add default via 172.0.0.1

# Node 2 setup
ip link add veth2 type veth peer name ceth2
ip link set veth2 up
ip link set ceth2 netns node2
ip netns exec node2 ip link set lo up
ip netns exec node2 ip link set ceth2 up
ip netns exec node2 ip addr add 172.0.0.3/24 dev ceth2
ip netns exec node2 ip route add default via 172.0.0.1

# Node 3 setup
ip link add veth3 type veth peer name ceth3
ip link set veth3 up
ip link set ceth3 netns node3
ip netns exec node3 ip link set lo up
ip netns exec node3 ip link set ceth3 up
ip netns exec node3 ip addr add 10.10.0.2/24 dev ceth3
ip netns exec node3 ip route add default via 10.10.0.1

# Node 4 setup
ip link add veth4 type veth peer name ceth4
ip link set veth4 up
ip link set ceth4 netns node4
ip netns exec node4 ip link set lo up
ip netns exec node4 ip link set ceth4 up
ip netns exec node4 ip addr add 10.10.0.3/24 dev ceth4
ip netns exec node4 ip route add default via 10.10.0.1

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
ip link add br1 type bridge
ip link set br1 up
ip link set veth1 master br1
ip link set veth2 master br1
ip link set veth00 master br1
ip addr add 172.0.0.1/24 dev br1

ip link add br2 type bridge
ip link set br2 up
ip link set veth3 master br2
ip link set veth4 master br2
ip link set veth01 master br2
ip addr add 10.10.0.1/24 dev br2

# Let bridges forward packets, otherwise they will drop them by default
iptables -A FORWARD -i br1 -j ACCEPT
iptables -A FORWARD -i br2 -j ACCEPT

