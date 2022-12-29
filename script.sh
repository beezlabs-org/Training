#!/bin/bash

cd /training/bin/tulip
function start() {
  cd $1
  port=$(awk -F = '{if ($1=="server.port") print $2}' application-private.properties)
  lsof -ti:"$port"
  if [ $? -eq 0 ]; then
    {
      if [ "$rflag" == "r" ]; then
        force_start $1
      else
        echo "$1 was already started and running in the $port"
        if [ "$kill" == "x" ]; then
          kill -9 $(lsof -ti:"$port")
          if [ $? -eq 0 ]; then
            echo "----------------------------------------"
            echo "$1 was killed successfully..."
            echo "----------------------------------------"
          fi
        fi
      fi
    }
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
  kill -9 $(lsof -ti:"$port")
  if [ $? -eq 0 ]; then
    echo "$1 was killed successfully..."
    echo "Restarting the $1 server, Plz be patient..."
    nohup java -jar app.jar >/dev/null 2>&1 &
    if [ $? -eq 0 ]; then
      echo "$1 is started on $port"
    fi
  fi
  echo ""
}

while getopts ":r :x :b :j :k :q :w :l" opt; do
  case "$opt" in
  r)
    rflag="$opt"
    ;;
  x)
    kill="$opt"
    ;;
  b)
    start "beekeeper" "$rflag" "$kill"
    ;;
  j)
    start "jhive" "$rflag" "$kill"
    ;;
  k)
    start "keyserver" "$rflag" "$kill"
    ;;
  q)
    start "queue" "$rflag" "$kill"
    ;;
  w)
    start "workflow" "$rflag" "$kill"
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
