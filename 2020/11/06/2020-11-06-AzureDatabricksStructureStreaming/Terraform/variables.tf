# Azure service principle secret
variable "subscription_id" {
    default = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
variable "client_id" {
    default = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
variable "client_secret" {
    default = "nxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
variable "tenant_id" {
    default = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
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
    default = "ssh-rsa XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}
