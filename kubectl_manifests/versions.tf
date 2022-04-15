terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
    httpclient = {
      source = "dmachard/http-client"
    }
  }
}