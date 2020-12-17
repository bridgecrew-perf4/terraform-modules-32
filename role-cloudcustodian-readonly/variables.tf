

variable "assumed_by_principals" {
    description = "The IAM principals that will assume this role"
    type        = "list"
}

variable "tags" {
    default = {}
    type    =   map
}
