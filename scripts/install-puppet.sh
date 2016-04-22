#!/usr/bin/env bash
set -e

release_url='https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb'
release_file="$(basename "$release_url")"

log() {
  echo '---> ' $*
}

puppet() {
  sudo /opt/puppetlabs/bin/puppet $*
}

is_installed() {
  dpkg -s "$1" &>/dev/null
}

install_puppet() {
  # remove puppet 3 if it exists
  if is_installed 'puppet'; then
    log 'removing puppet 3'
    sudo apt-get -yq --purge autoremove puppet
  fi

  # check if puppet 4 is already installed
  if is_installed 'puppet-agent'; then
    log 'puppet 4 already installed'
    return
  fi

  # install puppet repository
  if [[ ! -f /etc/apt/sources.list.d/puppetlabs-pc1.list ]]; then
    log 'adding puppet apt repository'
    curl -s -L -o "$release_file" "$release_url"
    sudo dpkg -i "$release_file"
    rm "$release_file"
    sudo apt-get update -q
  fi

  log 'installing puppet 4'
  sudo apt-get install -qy puppet-agent
}

install_modules() {
  local -a modules=(
    camptocamp/archive
  )
  for module in "${modules[@]}"; do
    log "puppet-module: installing $module"
    puppet module --modulepath=/etc/puppetlabs/code/modules install "$module"
  done
}

# main
install_puppet
install_modules
