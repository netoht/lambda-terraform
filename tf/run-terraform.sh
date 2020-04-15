#!/bin/bash
set -e

while getopts "he:" OPT; do
  case "$OPT" in
  "h") usage ;;
  "e") env=$OPTARG ;;
  esac
done

usage() {
  echo "$0 -e <Environment>"
}

[ -z $env ] && usage && exit 1

if ! [ -d .terraform ]; then
  terraform init -backend=true -backend-config=backend-config/$env
fi

if ! [ -e "./variables-$env.tfvar" ]; then
  echo "missing variables-$env.tfvar file"
  exit 1
fi

terraform apply -var-file variables-$env.tfvar
