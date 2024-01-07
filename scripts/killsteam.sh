#!/bin/bash
#/bin/bash -c '/usr/bin/pkill steam; exit 0'
function killsteam() {
  pkill steam
  return 0
}
killsteam
function killdiscord() {
  pkill discord
  return 0
}
killdiscord
