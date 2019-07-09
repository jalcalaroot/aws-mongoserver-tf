variable "access_key" {
  type        = "string"
  description = "indicar access_key IAM del ambiente donde desea crear el recurso EJEMPLO:AKIAIN*****"
}
variable "secret_key" {
  type        = "string"
  description = "indicar secret_key IAM del ambiente donde desear crear el recurso"
}
variable "servername" {
  type        = "string"
  description = "indicar el nombre del servidor"
}
variable "vpc_id" {
  type        = "string"
  description = "indicar el vpc_id de la vpc donde creara el recurso"
}
variable "subnetid_1" {
  type        = "string"
  description = "indicar el subnetid_1"
}
