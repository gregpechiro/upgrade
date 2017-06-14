#!/usr/bin/env bash

vercomp () {
    if [[ $1 == $2 ]]
    then
        echo 0
        return
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            echo 1
            return
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            echo 2
            return
        fi
    done
    echo 0
    return
}

echo -e '\n>>> Installing golang <<<\n'

VERSION="$1"
if [ "$VERSION" == "" ]; then
    VERSION=`wget -q https://golang.org/ -O - | grep -o 'Build version go[0-9]\.[0-9]*\.*[0-9]*' | sed 's/Build version go//g'`
fi

INSTALLED=""
CONDITION=$(which /usr/local/go/bin/go 2>/dev/null | grep -v "not found" | wc -l)
OV="$2"

if [ $CONDITION -eq 1 ] ; then
    INSTALLED=`/usr/local/go/bin/go version | grep -o '[0-9]\.[0-9]*\.*[0-9]*'`

    CONDITION=$(vercomp ${VERSION} ${INSTALLED})
    if [[ ($CONDITION == "0" || $CONDITION == "2") && "$OV" != "OVC" ]]; then
        echo -e "Installed version of go is the same or newer than the update version\nInstalled:\t${INSTALLED}\nUpdate:\t\t${VERSION}"
        exit 1
    fi
    if [ -d "/usr/local/go" ]; then
        echo "Removing old go..."
        sudo rm -rf /usr/local/go
    fi
fi

echo -e "Upgrading golang to version ${VERSION} ...\n"
echo "Downloading golang tarball..."
curl -o go${VERSION}.linux-amd64.tar.gz https://storage.googleapis.com/golang/go${VERSION}.linux-amd64.tar.gz

if [ ! -f "go${VERSION}.linux-amd64.tar.gz" ]; then
    echo "Download of new go version failed."
    exit 1
fi

echo "Extracting and installing into /usr/local/go..."
sudo tar -C /usr/local -xzf go${VERSION}.linux-amd64.tar.gz

echo "Removing golang tarball..."
rm go${VERSION}.linux-amd64.tar.gz

/usr/local/go/bin/go version
