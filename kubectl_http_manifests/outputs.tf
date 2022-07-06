output "this" {
  value = flatten([
  for s in data.kubectl_file_documents.http : [
  for k, v in s["manifests"] : {
    id   = k
    yaml = v
  }
  ]
  ])
}