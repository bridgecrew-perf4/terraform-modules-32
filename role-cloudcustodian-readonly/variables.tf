

variable "assumed_by_principals" {
    description = "The IAM principals that will assume this role"
    type    =   string
}

variable "tags" {
    default = {}
    type    =   map
}
