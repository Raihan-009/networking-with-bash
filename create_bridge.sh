#!/bin/bash

create_bridge_with_ip() {
  local bridge_name="v-net"
  local bridge_ip="10.0.0.1"
  local bridge_netmask="24"

  sudo ip link add name "$bridge_name" type bridge
  sudo ip link set dev "$bridge_name" up

  sudo ip addr add "$bridge_ip/$bridge_netmask" dev "$bridge_name"

  echo "Bridge '$bridge_name' created with IP address $bridge_ip/$bridge_netmask."
}

create_bridge_with_ip