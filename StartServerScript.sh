#!/usr/bin/env bash
force_launch() {
path=/home/abishek/tulip/"$1"
cd $path
read_port=$(cat application-private.properties)
port=$(echo $read_port | cut -c 13-16) #what about when port number has 5 digits?
 echo "shutting existing server"
 kill $(lsof -i:$port | awk 'NR==2 {print $2}')
 echo "launching the server"
  nohup java -jar app.jar >/dev/null 2>&1 &
  if [ $? -eq 1 ]; then
  echo "$server is started on $port"
  fi
cd ..
}
launch() {
  path=/home/abishek/tulip/"$1"
  cd $path
  read_port=$(cat application-private.properties)
  port=$(echo $read_port | cut -c 13-16) #what about when port number has 5 digits?
  check=$(netstat -an | grep $port | wc -l) #listener
  echo "$check"
  if [ "$check" -eq 0 ];then
    #jar file isnt running already
  echo "starting the server"
  nohup java -jar app.jar >/dev/null 2>&1 &
    echo "$server is started on $port"
  else
    force_launch $1
    fi
  cd ..
}
server_path() {
  while getopts "bjqwkfl" OPTION; do
          case $OPTION in

                  f)
                    force_server_path
                     break ;;
                  b)
                    launch "beekeeper" ;;

                  j)
                    launch "jhive" ;;

                  q)
                    launch "queue" ;;

                  k)
                    launch "keyserver" ;;

                  w)
                    launch "workflow" ;;
                  l)
                    lsof -i6 ;;
                  *)
                    echo -e "\nInvalid Command: No parameter included" >&2
                    echo -e "\nUsage :\n[-b] beekeeper,\n[-j] jhive,\n[-k] keyserver,\n[-q] queue,\n[-w] workflow,\n[-f] forcestart,\n[-l] list of running process" >&2
                    ;;

          esac
  done
}
force_server_path () {
  while getopts "bjqwkl" OPTION; do
            case $OPTION in

                    b)
                      force_launch "beekeeper" ;;

                    j)
                      force_launch "jhive" ;;

                    q)
                      force_launch "queue" ;;

                    k)
                      force_launch "keyserver" ;;

                    w)
                      force_launch "workflow" ;;

                    l)
                      lsof -i6 ;;

                    *)
                    echo -e "\nInvalid Command: No parameter included" >&2
                        echo -e "\nUsage :\n[-b] beekeeper,\n[-j] jhive,\n[-k] keyserver,\n[-q] queue,\n[-w] workflow,\n[-r] restart,\n[-l] list of running process" >&2
                        ;;
            esac
    done
}


