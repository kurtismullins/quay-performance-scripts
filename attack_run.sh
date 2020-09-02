#!/bin/bash

set -u

export QUAY_URL=<URL>  # e.g. staging.quay.io (no http/https)
export UUID=$(uuidgen)  # Used for run-to-run comparisons. The uuid passed to touchstone. 
export DURATION=120  # Amount of seconds to run each test for.
export PARALLELISM=10  # Number of jobs to be ran that are each querying a random user
export NUM_USERS=10 # Total number of users that were created/exist
export RATE=40 # Requests per second per job
export PREFIX=perf-test
export ES=search-cloud-perf-lqrf3jjtaqo7727m7ynd2xyt4y.us-west-2.es.amazonaws.com
export ES_PORT=80
export DB=mysql57
export TEST_NAME=perf_test
export QUAY_VERSION=3.3.0


kubectl delete ns quay-perf
kubectl create ns quay-perf
kubectl delete cm run-script -n quay-perf --ignore-not-found
kubectl create cm --from-file=run-script.sh run-script -n quay-perf
kubectl apply -f assets/role.yaml
kubectl apply -f assets/rolebinding.yaml
cat assets/run-vegeta-load.yaml | envsubst > run_job.yaml
kubectl apply -f run_job.yaml
