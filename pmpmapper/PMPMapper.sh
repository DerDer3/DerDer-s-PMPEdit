#!/bin/sh
echo -ne '\033c\033]0;PMPMapper\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/PMPMapper.x86_64" "$@"
