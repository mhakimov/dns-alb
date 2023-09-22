variable "aws_region" {
  default = "eu-west-2"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_count" {
  default = 2
}

variable "ami" {
  # default = "ami-0055e70f580e9ae80"
  default = "ami-07dc0b5cad2999c28"
}

variable "domain_name" {
  description = "Domain name of your website"
}

variable "hosted_zone_id" {
  description = "Id of the hosted zone you have created"
}

variable "id_rsa_pub" {
  description = "public key for connecting to EC2"
}