#!/usr/bin/env bash

path=/home/abishek/tulip
port_number() {
  cd $path/$1 || exit
  read_port=$(cat application-private.properties)
  port=$(echo $read_port | cut -c 13-17)
}
launch() {
  cd $path/$1 || exit
  port_number "$@"
  echo "$port"
  check=$(netstat -an | grep $port | wc -l)
  echo "$check"
  if [ "$check" -eq 0 ]; then
    echo "launching the server"
    nohup java -jar app.jar >/dev/null 2>&1 &
    echo "$1 is launched on $port"
  else
    if [ "$flag" == "f" ]; then
      force_launch $1
    else
      echo "$1 was already launched and running in the $port"
      if [ "$kill" == "x" ]; then
        if [ $? -eq 0 ]; then
          kill "$(lsof -i:$port | awk 'NR==2 {print $2}')"
          if [ $? -eq 0 ]; then
            echo "----------------------------------------"
            echo "$1 was killed successfully..."
            echo "----------------------------------------"
          fi
        fi
      fi
    fi
  fi
  cd ..
}
force_launch() {
  port_number "$@"
  echo "shutting existing server"
  kill -9 $(lsof -i:$port | awk 'NR==2 {print $2}')
  echo "launching the server"
  nohup java -jar app.jar >/dev/null 2>&1 &
  if [ $? -eq 0 ]; then
    echo "$1 is launched on $port"
  fi
  cd ..
}
while getopts ":f :x :b :j :k :q :w :l" OPTION; do
  case "$OPTION" in
  f)
    flag="$OPTION"
    ;;
  x)
    kill="$OPTION"
    ;;
  b)
    launch "beekeeper" "$flag" "$kill"
    ;;
  j)
    launch "jhive" "$flag" "$kill"
    ;;
  k)
    launch "keyserver" "$flag" "$kill"
    ;;
  q)
    launch "queue" "$flag" "$kill"
    ;;
  w)
    launch "workflow" "$flag" "$kill"
    ;;
  l)
    lsof -i6
    ;;
  *)
    echo -e "\nInvalid Command: No parameter included" >&2
    echo -e "\nUsage :\n[-b] beekeeper,\n[-j] jhive,\n[-k] keyserver,\n[-q] queue,\n[-w] workflow,\n[-r] relaunch,\n[-l] list of running process" >&2
    ;;
  esac
done
echo ""