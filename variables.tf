variable "region" {
  type        = string
  description = ""
  default     = "us-east-1"
}

variable "cidr_block" {
  description = ""
  type        = string
  default     = "0.0.0.0/0"
}

variable "az_1a" {
  type        = string
  description = ""
  default     = "us-east-1a"
}

variable "az_1b" {
  type        = string
  description = ""
  default     = "us-east-1b"
}