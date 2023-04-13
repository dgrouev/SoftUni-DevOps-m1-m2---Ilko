
variable "v_image_web" {
  description = "Image"
  default =  "shekeriev/bgapp-web"
}
variable "v_con_name_web" {
  description = "Container name"
  default = "con-web"
}
variable "v_int_port_web" {
  description = "Internal port"
  default = 80
}
variable "v_ext_port_web" {
  description = "External port"
  default = 8080
}


variable "v_image_db" {
  description = "Image"
  default =  "shekeriev/bgapp-db"
}
variable "v_con_name_db" {
  description = "Container name"
  default = "con-db"
}
variable "v_int_port_db" {
  description = "Internal port"
  default = 3306
}
variable "v_ext_port_db" {
  description = "External port"
  default = 3306
}
