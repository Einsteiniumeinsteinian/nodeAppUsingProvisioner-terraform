variable "access_key" {}
variable "secret_key" {}

variable "AWS_REGION" {
default = "eu-west-3"
}

# variable "Security_Group"{
#     type = list
#     default = ["sg-24076", "sg-90890", "sg-456789"]
# }

variable "PATH_TO_PRIVATE_KEY" {
  default = "terraform"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "terraform.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}
