#!/usr/bin/env bash

KUBE_CONFIG=${1}
NAMESPACE=${2}
RESOURCE_KIND=${3}
RESOURCE_NAME=${4}

case ${RESOURCE_KIND} in
  cronjob) QUERY='{.spec.jobTemplate.spec.template.spec.containers[0].image}';;
  deployment) QUERY='{.spec.template.spec.containers[0].image}';;
esac

TAG=$(kubectl get --kubeconfig <(echo "${KUBE_CONFIG}") --namespace "${NAMESPACE}" "${RESOURCE_KIND}" "${RESOURCE_NAME}" -o jsonpath="${QUERY}" | awk -F: '{print $2}')
[[ -z ${TAG} ]] && TAG="latest"
echo "{\"tag\": \"${TAG}\"}"
