#!/bin/bash

delete_namespaces() {
  sudo ip netns delete red
  sudo ip netns delete blue
  echo "Network namespaces 'red' and 'blue' deleted."
}

delete_namespaces