    #!/usr/bin/env bash
    path=/home/abishek/tulip
    launch() {
      cd $path/$1
      read_port=$(cat application-private.properties)
      port=$(echo $read_port | cut -c 13-17) #attt
      check=$(netstat -an | grep $port | wc -l)
      echo "$check"
      if [ "$check" -eq 0 ];then
      echo "starting the server"
      nohup java -jar app.jar >/dev/null 2>&1 &
        echo "$1 is started on $port"
      else
        force_launch $1
        fi
      cd ..
    }
    force_launch() {
    cd $path/$1 || exit
    read_port=$(cat application-private.properties)
    port=$(echo $read_port | cut -c 13-17) #attt
     echo "shutting existing server"
     kill $(lsof -i:$port | awk 'NR==2 {print $2}')
     echo "launching the server"
      nohup java -jar app.jar >/dev/null 2>&1 &
      if [ $? -eq 0 ]; then
      echo "$1 is started on $port"
      fi
    cd ..
    }
    force_server_path () {
            while getopts "bjqwkl" OPTION; do
                      case "$OPTION" in

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







