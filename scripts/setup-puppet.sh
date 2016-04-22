#!/usr/bin/env bash
set -e

log() {
  echo '---> ' $*
}

puppet() {
  sudo /opt/puppetlabs/bin/puppet $*
}

log 'copying puppet code'
sudo cp -r /home/ubuntu/puppet/* /etc/puppetlabs/code
rm -rf /home/ubuntu/puppet

log 'running puppet apply'
puppet apply /etc/puppetlabs/code/environments/production/manifests
