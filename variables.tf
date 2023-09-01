variable "instance_count" {
    default = 2
}

variable "domain_name" {
    description = "Domain name of your website"
}

variable "hosted_zone_id" {
    description = "Id of the hosted zone you have created"
}