#!/bin/bash

create_namespaces() {
  sudo ip netns add red
  sudo ip netns add blue
  echo "Network namespaces 'red' and 'blue' created."
}

create_namespaces