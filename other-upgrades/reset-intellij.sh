#!/usr/bin/env bash

if ls /home/greg/.IntelliJIdea*/config/eval 1> /dev/null 2>&1; then
    echo -e '\n>>> Reseting Intellij Idea <<<'
    rm -rf /home/greg/.IntelliJIdea*/config/eval
fi
