#===========================================================================================
# Rainbow Gravity's Inrastructure for exam
# 
# Variables
#===========================================================================================

# Tags
variable "Environment_Tag" {
  type    = string
  default = "Exam"
  validation {
    condition     = length(var.Environment_Tag) <= 5 && length(var.Environment_Tag) >= 1
    error_message = "Maximum lenght of the Environment tag is 5, because it used as name prefix for several resources."
  }
}
variable "Project_Tag" {
  type    = string
  default = "Exam Infrastructure"
}
variable "Owner_Tag" {
  type    = string
  default = "Rainbow Gravity"
}

# Blue Container params
variable "Blue_App" {
  type = map(number)
  default = {
    port   = 8080
    amount = 4
    cpu    = 128
    memory = 128
  }
}

# Blue Container repository and tag
variable "Blue_Container" {
  type    = string
  default = "068379437484.dkr.ecr.eu-central-1.amazonaws.com/python-app-blue:blau"
}

# Region selection
variable "Region" {
  type    = string
  default = "eu-central-1"
}
