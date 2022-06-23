#!/usr/bin/env bash

echo '{"ip_address": "'"$(dig @168.63.129.16 +short "${1}")"'"}'