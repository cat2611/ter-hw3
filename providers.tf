terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.14.0"
}

provider "yandex" {
  service_account_key_file = "/root/key3.json"
  #  token     = var.token Измененная политка Яндекс не позовляет больше проводить аутентификацию таким способом
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}
