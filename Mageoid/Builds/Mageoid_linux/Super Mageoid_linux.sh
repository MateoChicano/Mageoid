#!/bin/sh
printf '\033c\033]0;%s\a' Super Mageoid
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Super Mageoid_linux.x86_64" "$@"
