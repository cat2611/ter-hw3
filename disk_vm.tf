resource "yandex_compute_disk" "extra_disk" {
  count = 3
  name  = "extra-disk-${count.index + 1}"
  type  = "network-hdd"
  zone  = "ru-central1-a"
  size  = 1
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.extra_disk
    content {
      disk_id     = secondary_disk.value.id
      auto_delete = false
    }
  }
}
