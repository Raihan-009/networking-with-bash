#!/bin/bash

cleanup_network() {
  local ns1="red"
  local ns2="blue"

  sudo ip netns delete $ns1
  sudo ip netns delete $ns2

  echo "Cleanup: Deleted network namespaces and virtual Ethernet connections."
}

cleanup_network