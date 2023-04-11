output "container-id_web" {
  value = docker_container.con-web.id
}

output "container-name_web" {
  value = docker_container.con-web.name
}

output "image_out_web" {
  value = docker_image.img-web.name
}


output "image_out_db" {
  value = docker_image.img-db.name
}

output "container-id_db" {
  value = docker_container.con-db.id
}

output "container-name_db" {
  value = docker_container.con-db.name
}
