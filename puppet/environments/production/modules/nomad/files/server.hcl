# vim: set ft=terraform:

data_dir = "/var/lib/nomad/server"

server {
  enabled = true
  bootstrap_expect = 1
}
