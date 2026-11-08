variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))
  default = [
    {
      vm_name     = "main"
      cpu         = 2
      ram         = 2
      disk_volume = 10
    },
    {
      vm_name     = "replica"
      cpu         = 4
      ram         = 4
      disk_volume = 20
    }
  ]
}

resource "yandex_compute_instance" "for_each_vm" {
  for_each = { for vm in var.each_vm : vm.vm_name => vm }

  name        = each.value.vm_name
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = 20 # <-- добавлено
  }

  scheduling_policy {
    preemptible = true # <-- добавлено
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = each.value.disk_volume
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }
}
