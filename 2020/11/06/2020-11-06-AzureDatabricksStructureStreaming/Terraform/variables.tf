# Azure service principle secret
variable "subscription_id" {
    default = "15e95d2e-6cd0-4d1c-96da-b8e055a62ee8"
}
variable "client_id" {
    default = "70641ad5-a43e-409e-868e-785afc3dabd3"
}
variable "client_secret" {
    default = "nR-JBiM_ULC_Tm9znq8.ZG2bT57To1lPMS"
}
variable "tenant_id" {
    default = "71adee5d-7b4b-4e47-8814-ade2a984a543"
}

# Azure IaaS Configuration
variable lab_namespace {
    default = "streamingdemo"
}
variable location {
    default = "chinanorth2"
}

# Azure Kubernetes Service configuration
variable "admin_username" {
    default = "centos"
}
variable "ssh_public_key_data" {
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwUEvg5jYspue1gkdnT+qfHh50MPXFbaKEfgVACMjPZeQDkav4El7WAMQCppyBH5fkc1wvc7I064/VPXcW6khHymvOrBHOio2/IeNqGmJv3E/FUHgSxKDLQKLzkev+q7f3qhzE1DC9FVvikcVnCYAPeHs7F0NtmgHhV83TRL3Pm1NWV2pl++x4p7+Aue4clLlkCxg8CWhX7nlMBm2FgWSmilnw1sOpFFeQhvZ/Zqe1qF7jOkx+2lfmZL7ODxIzeC/VrATH4edrd0W3P1VAkj5TgnPdF1ad70MM8hzDKjgebenpoaK0E11aitzWuuX0yspBLOjHG4yWcSQjp56Onh2/"
}



