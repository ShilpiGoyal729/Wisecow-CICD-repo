#!/usr/bin/env bash

SRVPORT=4499
RSPFILE=response

rm -f $RSPFILE
mkfifo $RSPFILE

get_api() {
    read line
    echo $line
}

handleRequest() {
    # Process the request
    get_api
    mod=$(fortune)

    cat <<EOF > $RSPFILE
HTTP/1.1 200


<pre>$(cowsay "$mod")</pre>
EOF
}

prerequisites() {
    command -v cowsay >/dev/null 2>&1 &&
    command -v fortune >/dev/null 2>&1 &&
    command -v nc >/dev/null 2>&1 ||
    { 
        echo "Install prerequisites."
        exit 1
    }
}

main() {
    prerequisites
    echo "Wisdom served on port=$SRVPORT..."

    # Background task to update index.html every 5 seconds
    while true; do
        echo "<pre>$(fortune | cowsay)</pre>" > /usr/share/nginx/html/index.html
        sleep 5
    done &  

    while true; do
        cat $RSPFILE | nc -lk $SRVPORT | handleRequest
        sleep 0.01
    done
}

main
