resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/hosts.tftpl", {
    webservers = yandex_compute_instance.web
    databases  = values(yandex_compute_instance.for_each_vm)
    storage    = [yandex_compute_instance.storage] # <-- обернули в список
  })
  filename = "${abspath(path.module)}/hosts.ini"
}
