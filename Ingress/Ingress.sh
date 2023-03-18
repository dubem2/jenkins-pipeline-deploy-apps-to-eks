#!/bin/bash
# method 1: with Helm
# at the time of writing this gist, Helm doesn't support upgrading nor removing CRDs
# https://helm.sh/docs/chart_best_practices/custom_resource_definitions/#some-caveats-and-explanations
helm install -n ingress-aws --create-namespace aws-load-balancer-controller-crds aws-load-balancer-controller-crds/aws-load-balancer-controller-crds --version 1.3.3

# method 2: without Helm; source: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/deploy/installation/#summary
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
