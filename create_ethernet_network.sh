#!/bin/bash

create_network() {
  local ns1="red"
  local ns2="blue"
  local veth1="${ns1}-veth"
  local veth2="${ns2}-veth"

  sudo ip netns add $ns1
  sudo ip netns add $ns2

  sudo ip link add $veth1 type veth peer name $veth2

  sudo ip link set $veth1 netns $ns1
  sudo ip link set $veth2 netns $ns2

  sudo ip netns exec $ns1 ip addr add 10.0.0.1/24 dev $veth1
  sudo ip netns exec $ns1 ip route add default via 10.0.0.1 dev $veth1

  sudo ip netns exec $ns2 ip addr add 10.0.0.2/24 dev $veth2
  sudo ip netns exec $ns2 ip route add default via 10.0.0.2 dev $veth2

  sudo ip netns exec $ns1 ip link set dev $veth1 up
  sudo ip netns exec $ns2 ip link set dev $veth2 up

  sudo ip netns exec $ns1 sysctl -w net.ipv4.ip_forward=1
  sudo ip netns exec $ns2 sysctl -w net.ipv4.ip_forward=1

  echo "Network namespaces 'red' and 'blue' created with a virtual Ethernet connection."
}

create_network