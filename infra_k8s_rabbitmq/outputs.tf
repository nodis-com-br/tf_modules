output "credentials" {
  value = {
    username = data.kubernetes_secret.default_user[0].data.username
    password = data.kubernetes_secret.default_user[0].data.password
  }
}