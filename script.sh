#!/bin/bash

cd /training/bin/tulip
function start() {
  cd $1
  read_port=$(cat application-private.properties)
  port=$(echo $read_port | cut -c 13-16)
  lsof -ti:"$port"
  if [ $? -eq 0 ]; then
    if [ "$rflag" == "r" ]; then
      force_start $1
    else
      echo "$1 was already started and running in the $port"
    fi
  else
    nohup java -jar app.jar >/dev/null 2>&1 &
    if [ $? -eq 0 ]; then
      echo "$1 is started on $port"
    fi
  fi
  cd ..
  echo ""
}
function force_start() {
  if [ $? -eq 0 ]; then
    kill -9 $(lsof -ti:"$port")
    if [ $? -eq 0 ]; then
      echo "$1 was killed successfully..."
      echo "Restarting the $1 server, Plz be patient..."
      nohup java -jar app.jar >/dev/null 2>&1 &
      if [ $? -eq 0 ]; then
        echo "$1 is started on $port"
      fi
    fi
  fi
  echo ""
}
while getopts ":r :b :j :k :q :w :l" opt; do
  case "$opt" in
  r)
    rflag="$opt"
    ;;
  b)
    start "beekeeper" "$rflag"
    ;;
  j)
    start "jhive" "$rflag"
    ;;
  k)
    start "keyserver" "$rflag"
    ;;
  q)
    start "queue" "$rflag"
    ;;
  w)
    start "workflow" "$rflag"
    ;;
  l)
    lsof -i6
    ;;
  *)
    echo -e "\nInvalid Command: No parameter included" >&2
    echo -e "\nUsage :\n[-b] beekeeper,\n[-j] jhive,\n[-k] keyserver,\n[-q] queue,\n[-w] workflow,\n[-r] restart,\n[-l] list of running process" >&2
    ;;
  esac
done
echo ""
