#!/bin/bash

## Arguments
# --address: the IP or URL address of the proxy
# --port: the port of the proxy
# --state: 'on' or 'off'

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -a|--address)
    ADDRESS="$2"
    shift # past argument
    shift # past value
    ;;
		-p|--port)
    PORT="$2"
    shift # past argument
    shift # past value
    ;;
    -s|--state)
    STATE="$2"
    shift # past argument
    shift # past value
    ;;		
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

## ------------------------- Functions ------------------------- ##

getProxyStatus () {
	echo "## Environment Variables:"
	env | grep -i "_proxy"
	echo "## git proxy [http] = $(git config --global --get http.proxy)"	
	echo "## npm proxy [http] = $(npm config get --global proxy)"
}

setEnvProxy () {
	unsetEnvProxy
	echo $ENVCONFIG | cat >> $ENVPROXYFILE
}

unsetEnvProxy () {
	tmp=`mktemp`
	awk '!/^\w+_proxy/' $ENVPROXYFILE > $tmp
	chmod 0644 $tmp
	sudo mv -f $tmp $ENVPROXYFILE
	rm -rf $tmp
}

setAptProxy () {
	# remove current settings
	unsetAptProxy
	# write new settings
	tmp=`mktemp`
	printf "$APTCONFIG" > $tmp && chmod 0644 $tmp && sudo mv -f $tmp $APTPROXYFILE
	rm -rf $tmp
}

unsetAptProxy () {
	tmp=`mktemp`
	printf "" > $tmp && chmod 0644 $tmp && sudo mv -f $tmp $APTPROXYFILE
	rm -rf $tmp
}

setGitProxy () {
	git config --global http.proxy $ADDRESS:$PORT
	git config --global https.proxy $ADDRESS:$PORT
}

unsetGitProxy () {
	git config --global --unset http.proxy
	git config --global --unset https.proxy
}

setNpmProxy () {
	npm config set proxy http://$ADDRESS:$PORT
	npm config set https-proxy http://$ADDRESS:$PORT
}

unsetNpmProxy () {
	npm config delete proxy
	npm config delete https-proxy
}

setGnomeProxy () {
	
	gsettings set org.gnome.system.proxy mode $MODE_MANUAL
	gsettings set org.gnome.system.proxy.http host $ADDRESS
	gsettings set org.gnome.system.proxy.http port $PORT
	gsettings set org.gnome.system.proxy.https host $ADDRESS
	gsettings set org.gnome.system.proxy.https port $PORT
	gsettings set org.gnome.system.proxy.ftp host $ADDRESS
	gsettings set org.gnome.system.proxy.ftp port $PORT
	gsettings set org.gnome.system.proxy.socks host $ADDRESS
	gsettings set org.gnome.system.proxy.socks port $PORT
	#gsettings set org.gnome.system.proxy ignore-hosts $IGNOREHOSTS

}

unsetGnomeProxy () {
	gsettings set org.gnome.system.proxy mode $MODE_NONE
}


setAllProxy () {
	setAptProxy
	setEnvProxy
	setGitProxy
	setNpmProxy
	setGnomeProxy
}

unsetAllProxy () {
	unsetAptProxy
	unsetEnvProxy
	unsetGitProxy
	unsetNpmProxy
	unsetGnomeProxy
}


# -------------------------------

APTPROXYFILE="/etc/apt/apt.conf.d/95proxies"
APTCONFIG="Acquire::http::proxy \"http://$ADDRESS:$PORT/\";\nAcquire::https::proxy \"https://$ADDRESS:$PORT/\";\nAcquire::ftp::proxy \"ftp://$ADDRESS:$PORT/\";\nAcquire::socks::proxy \"socks://$ADDRESS:$PORT/\";"

ENVPROXYFILE="/etc/environment"
ENVCONFIG="http_proxy=\"http://$ADDRESS:$PORT/\"\nhttps_proxy=\"http://$ADDRESS:$PORT/\"\nftp_proxy=\"ftp://$ADDRESS:$PORT/\"\nsocks_proxy=\"socks://$ADDRESS:$PORT/\""

MODE_MANUAL="manual"
MODE_NONE="none"
IGNOREHOSTS="['localhost', '127.0.0.0/8', '10.0.0.0/8', '192.168.0.0/16', '172.16.0.0/12']"

if [ $STATE == 'on' ] && [ -n $ADDRESS ] && [ -n $PORT ]; then
	echo "Setting proxy configuration..."
	setAllProxy
	exit 0
fi

if [ $STATE == 'off' ] && [ -n $ADDRESS ] && [ -n $PORT ]; then
	echo "Removing proxy configuration..."
	unsetAllProxy
	exit 0
fi

if [ $STATE == 'show' ]; then
	echo "Proxy status..."
	getProxyStatus
	exit 0
fi
