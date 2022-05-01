locals {
  http_manifests = var.type == "http" ? flatten([
    for s in data.kubectl_file_documents.http : [
      for k, v in s.manifests : {
        id = k
        yaml = v
      }
    ]
  ]) : []
  file_manifests = var.type == "file" ? flatten([
    for s in data.kubectl_file_documents.file : [
      for k, v in s.manifests : {
        id = k
        yaml = v
      }
    ]
  ]) : []
  manifests = concat(local.http_manifests, local.file_manifests)
}