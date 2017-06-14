#!/usr/bin/env bash

if [ -d "/home/greg/.IntelliJIdea2017.1/config/eval" ]; then
    echo -e '\n>>> Reseting Intellij Idea <<<'
    rm -rf /home/greg/.IntelliJIdea2017.1/config/eval
fi
