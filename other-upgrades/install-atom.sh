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

echo -e '\n>>> Installing atom <<<\n'

CURRENT=`wget -q https://atom.io/docs -O - | grep -o '<h3 class="center subheader">.*</h3>' | sed 's/<[^>]\+>//g' | sed 's/Current Version: v//g'`
CONDITION=$(which atom 2>/dev/null | grep -v "not found" | wc -l)

if [ $CONDITION -eq 1 ] ; then
    INSTALLED=`atom --version | grep -o 'Atom[ ].*[0-9]\.[0-9]*\.*[0-9]*' | sed -r 's/Atom[ ].+:[ ]*//g'`
    CONDITION=$(vercomp ${CURRENT} ${INSTALLED})
    if [[ ($CONDITION == "0" || $CONDITION == "2") ]]; then
        echo -e "Installed version of Atom is the same or newer than the current version\nCurrent:\t${CURRENT}\nInstalled:\t${INSTALLED}"
        exit 1
    fi
fi
echo -e "Upgrading Atom to version ${CURRENT} ...\n"
echo -e "Downloading Atom .deb ...\n"

wget https://atom.io/download/deb -O /tmp/atom_${CURRENT}.deb

echo -e "Installing Atom...\n"

sudo dpkg -i /tmp/atom_${CURRENT}.deb

echo -e "Finished Atom Install\n"

atom --version
