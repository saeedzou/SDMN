#!/bin/bash

#   This script deletes the namespaces and bridges created by the
#   create_network.sh script
#   first >>chmod 755 del.sh
#   then >>./del.sh

ip netns delete node1
ip netns delete node2
ip netns delete node3
ip netns delete node4
ip netns delete router
ip link delete br1
ip link delete br2





