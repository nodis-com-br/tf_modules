locals {
  http_manifests = flatten([
    for s in data.kubectl_file_documents.http : [
      for k, v in s.manifests : v
    ]
  ])
}