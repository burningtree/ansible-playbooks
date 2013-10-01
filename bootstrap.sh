#!/bin/sh

# Bootstrap
# Basic things as install package manager and Ansible.

os=`uname -s`

###########################################
# Darwin (Mac OS X)                       #
###########################################

if [ $os = Darwin ]; then

  echo "Darwin (Mac OS X) bootstrapping .."

  ###########################################
  # ensure homebrew                         #
  ###########################################

  echo "Checking for homebrew .."

  if [ ! -f /usr/local/bin/brew ]; then

    # install homebrew
    echo "Homebrew not installed, installing .."
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

    if [ $? != 0 ]; then
      echo "Error installing homebrew."
      exit 1
    fi

    echo "Homebrew installed."
  fi

  echo "Homebrew: $(brew --version)"

  ###########################################
  # basic brew packages                     #
  ###########################################

  packages="ack ansible git"
  echo "Checking for basic brew packages [ $packages ] .."

  for pkg in $packages; do

    package_files=`brew ls $pkg &>/dev/null`
    if [ $? != 0 ]; then
      echo "Installing brew package: $pkg .."

      `brew install $pkg`
      if [ !$? ]; then
        echo "Error: failed installing package: $pkg"
      fi
    fi

    echo "Package: $(brew info $pkg | ack "$pkg: (\w+ \d+)")"
  done

  echo "Bootstrap done!"

else
  echo "Error: Unknown OS: $os"
  exit 1
fi

