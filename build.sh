#!/usr/bin/env bash
URL="https://raw.githubusercontent.com/tanakh/cmdline/refs/heads/master/cmdline.h"

# Build command
build() {
# Download the release
if [ ! -f "cmdline.h" ]; then
  echo "Downloading cmdline.h from $URL ..."
  curl -L "$URL" -o "cmdline.h"
  echo ""
fi
}


# Test command
test() {
  echo "Testing cmdline.cxx ..."
  clang++ -std=c++17 -I. examples/01-test.cxx -o test
  ./test
  clang++ -std=c++17 -I. examples/02-test.cxx -o test
  ./test
  echo ""
}


# Main
if [[ "$1" == "test" ]]; then test; else build; fi
