#!/bin/bash

create_bridge_connection() {
  local bridge_name="v-net"
  local bridge_ip="10.0.0.1"
  local bridge_netmask="24"
  local ns1="red"
  local ns2="blue"
  local veth1_ns="${ns1}-veth-ns"
  local veth1_br="${ns1}-veth-br"
  local veth2_ns="${ns2}-veth-ns"
  local veth2_br="${ns2}-veth-br"
  local ns1_ip="10.0.0.10"
  local ns2_ip="10.0.0.20"

  sudo ip link add dev "$bridge_name" type bridge
  sudo ip link set dev "$bridge_name" up
  sudo ip addr add "$bridge_ip/$bridge_netmask" dev "$bridge_name"

  sudo ip netns add $ns1
  sudo ip netns add $ns2

  sudo ip link add $veth1_ns type veth peer name $veth1_br
  sudo ip link add $veth2_ns type veth peer name $veth2_br

  sudo ip link set dev $veth1_ns netns $ns1
  sudo ip link set dev $veth2_ns netns $ns2

  sudo ip link set dev $veth1_br master "$bridge_name"
  sudo ip link set dev $veth2_br master "$bridge_name"

  sudo ip link set dev $veth1_br up
  sudo ip link set dev $veth2_br up

  sudo ip netns exec $ns1 ip link set dev $veth1_ns up
  sudo ip netns exec $ns2 ip link set dev $veth2_ns up

  sudo ip netns exec $ns1 ip addr add "$ns1_ip/$bridge_netmask" dev $veth1_ns
  sudo ip netns exec $ns1 ip route add default via $bridge_ip
  sudo ip netns exec $ns2 ip addr add "$ns2_ip/$bridge_netmask" dev $veth2_ns
  sudo ip netns exec $ns2 ip route add default via $bridge_ip

  sudo ip netns exec $ns1 sysctl -w net.ipv4.ip_forward=1
  sudo ip netns exec $ns2 sysctl -w net.ipv4.ip_forward=1

  sudo iptables --append FORWARD --in-interface $bridge_name --jump ACCEPT
  sudo iptables --append FORWARD --out-interface $bridge_name --jump ACCEPT
}

create_bridge_connection