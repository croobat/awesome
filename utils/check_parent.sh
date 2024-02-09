#!/bin/bash

ppid() {
  local ppid
  ppid=$(ps -o ppid= -p "$1")
  printf '%s' "$ppid" | xargs
}

gppid() {
  PARENT=$(ps -o ppid= -p "$1")
  GRANDPARENT=$(ps -o ppid= -p "$PARENT")
  printf '%s' "$GRANDPARENT" | xargs
}

"$@"
