#!/bin/bash

#help function
function usage(){
	printf "\nUsage: $0 [ IP of server ] [ Directory for git storage ]\n
	Options:
		[ IP of server ] - self explanatory."
	exit 1
}

# if no args
if [ $# -eq 0 ]; then
	usage
	exit 1
fi

# copy ssh key
ssh-copy-id root@$1

# copy over server script
scp ./server-init.sh root@$1:~/ >/dev/null 2>&1