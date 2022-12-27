#!/usr/bin/env bash
echo "Please enter the name of the server you want to start"
read server
path=/training/bin/tulip/"$server"
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
  #jar file is running already so kill it and start it
 echo "shutting the existing server down"
 kill -9 $(lsof -ti:$port)
 echo "starting the new server"
  nohup java -jar app.jar >/dev/null 2>&1 &
  if [ $? -eq 1 ]; then
  echo "$server is started on $port"
  fi
fi
cd ..
exit 0

