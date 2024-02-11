#!/bin/bash

ppid() {
  printf "$(ps -o ppid= -p $1)" | xargs
}

gppid() {
  PARENT=$(ps -o ppid= -p $1)
  GRANDPARENT=$(ps -o ppid= -p $PARENT)
  printf "$GRANDPARENT" | xargs
}

$@
