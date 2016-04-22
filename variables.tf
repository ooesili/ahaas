variable "key_name" {
  type = "string"
  description = "Name for AWS SSH key pair"
}

variable "public_key_path" {
  type = "string"
  description = "Path to SSH public key to use for the EC2 instance"
}
