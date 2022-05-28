#!/usr/bin/env bash

GITHUB_TOKEN=${1}
REPOSITORY=${2}
ENVIRONMENT=${3}

case ${ENVIRONMENT} in
  dev) MODIFIER="-dev\.[0-9]+";;
  quality) MODIFIER="-rc\.[0-9]+";;
esac

TAG=$(curl -H "Accept: application/vnd.github.v3+json" "https://:${GITHUB_TOKEN}@api.github.com/repos/${REPOSITORY}/tags?per_page=100" 2> /dev/null | jq -r '.[].name' | grep -E "^v[0-9]+\.[0-9]+\.[0-9]+${MODIFIER}$" | head -n 1)
[[ -n ${TAG} ]] && TAG="${TAG/v/:}"
echo "{\"tag\": \"${TAG}\"}"
