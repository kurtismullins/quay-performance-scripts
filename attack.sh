#!/bin/bash

set -u

export TOKEN=<Token>
export QUAY_URL=<URL>
export PARALLELISM=200
export POD_COUNT=200
export NUM_USERS=500
export NUM_IMAGES=100
export NUM_TAGS=10

kubectl create ns quay-perf
kubectl delete cm load-script -n quay-perf --ignore-not-found
kubectl create cm --from-file=build-script.sh load-script -n quay-perf
kubectl apply -f assets/role.yaml
kubectl apply -f assets/rolebinding.yaml
cat assets/create-container-image-job.yaml | envsubst > newjob.yaml
kubectl apply -f newjob.yaml

