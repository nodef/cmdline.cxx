#!/usr/bin/env bash
# Fetch the latest version of the library
fetch() {
URL="https://raw.githubusercontent.com/tanakh/cmdline/refs/heads/master/cmdline.h"
if [ -f "cmdline.h" ]; then return; fi

# Download the release
echo "Downloading cmdline.h from $URL ..."
curl -L "$URL" -o "cmdline.h"
echo ""
}


# Test the project
test() {
echo "Running 01-basic.cxx ..."
clang++ -std=c++17 -I. -o 01.exe examples/01-basic.cxx    && ./01 && echo -e "\n"
echo "Running 02-advanced.cxx ..."
clang++ -std=c++17 -I. -o 02.exe examples/02-advanced.cxx && ./02 && echo -e "\n"
}


# Main script
if [[ "$1" == "test" ]]; then test
elif [[ "$1" == "fetch" ]]; then fetch
else echo "Usage: $0 {fetch|test}"; fi
