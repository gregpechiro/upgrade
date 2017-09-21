#!/usr/bin/env bash

if [ -d "/home/greg/.IntelliJIdea*/config/eval" ]; then
    echo -e '\n>>> Reseting Intellij Idea <<<'
    rm -rf /home/greg/.IntelliJIdea*/config/eval
fi
