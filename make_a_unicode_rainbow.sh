#!/bin/sh -f

# Twitter @climagic

printf "%x\n" {1..65535} | while read -r u ; do printf "\033[38;5;$((16+$((16#$u))%230))m\u$u\033[0m"; done
