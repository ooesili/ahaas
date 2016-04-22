# vim: set ft=terraform:

data_dir = "/var/lib/nomad/client"

client {
  enabled = true
  servers = ["localhost:4647"]
}

ports {
  http = "5656"
}
