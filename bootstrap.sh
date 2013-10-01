#!/bin/sh

# Bootstrap
# Basic things as install package manager and Ansible.

MYSETUP_INSTALL_URL="https://raw.github.com/burningtree/mysetup/master/tools/install.sh"
MYSETUP_TAP="https://github.com/burningtree/ansible-playbooks"

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

  packages="ack ansible"
  echo "Checking for basic brew packages [ $packages ] .."

  for pkg in $packages; do

    package_files=`brew ls $pkg &>/dev/null`
    if [ $? != 0 ]; then
      echo "Installing brew package: $pkg .."

      `brew install $pkg`
      if [ $? != 0 ]; then
        echo "Error: failed installing package: $pkg"
      fi
    fi

    echo "Package: $(brew info $pkg | ack "$pkg: (\w+ \d+)")"
  done

else
  echo "Error: Unknown OS: $os"
  exit 1
fi

###########################################
# OS independent                          #
###########################################

###########################################
# mysetup installation                    #
###########################################

# check if installed
mysetup_dir="$HOME/.mysetup"
mysetup_bin="$mysetup_dir/bin/mysetup"

if [ ! -f $mysetup_bin ]; then
  echo "Installing mysetup .."
  curl -s $MYSETUP_INSTALL_URL | sh >/dev/null

  if [ $? != 0 ]; then
    echo "error: installation of 'mysetup' failed"
    exit 10
  fi
fi

mysetup_version=`$mysetup_bin version`
echo "mysetup: $mysetup_version"

if [ ! -d "$mysetup_dir/repo" ]; then
  echo "Tapping config in mysetup .."
  $HOME/.mysetup/bin/mysetup tap $MYSETUP_TAP >/dev/null
fi

echo "Bootstrap done!"

