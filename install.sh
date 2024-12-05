#!/usr/bin/env bash

install -m 744 remote-spec ~/.remote-spec
install -m 644 framework.sh ~/.remote-spec

echo "Add the following to your .bashrc"
echo "export PATH=\$PATH:~/.remote-spec"
echo "Create a test with: remote-spec init <name_of_your_test>"
echo "Run it with: remote-spec run <name_of_your_test>"
