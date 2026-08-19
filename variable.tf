variable "project" {
    type = string
}

variable "environment" {
    type = string
}

variable "cidr_block" {
    type = string
    default = "10.0.0.0/16"
}

variable "vpc-final-tags" {
    type = map(string)
}

variable "igw-final-tags" {
    type = map(string)
}

variable "public-subnet-cidrs" {
    type = list
    default = ["10.0.1.0/24" , "10.0.2.0/24"]
}

variable "public-subnet-tags" {
    type = map
    default = {}
}

variable "private-subnet-cidrs" {
    type = list
    default = ["10.0.11.0/24" , "10.0.12.0/24"]
}

variable "private-subnet-tags" {
    type = map
    default = {}
}

variable "data-base-subnet-cidrs" {
    type = list
    default = ["10.0.21.0/24" , "10.0.22.0/24"]
}

variable "data-base-subnet-tags" {
    type = map
    default = {}
}