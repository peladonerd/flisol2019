#! /bin/bash
# exit script when any command ran here returns with non-zero exit code
set -e

COMMIT_SHA1=$CIRCLE_SHA1

# We must export it so it's available for envsubst
export COMMIT_SHA1=$COMMIT_SHA1

# since the only way for envsubst to work on files is using input/output redirection,
#  it's not possible to do in-place substitution, so we need to save the output to another file
#  and overwrite the original with that one.
envsubst < ./.circleci/kube/deployment.yml.template > ./.circleci/kube/deployment.yml

echo "$KUBERNETES_KUBECONFIG" | base64 --decode > kubeconfig.yml

./kubectl --kubeconfig=kubeconfig.yml get nodes

./kubectl --kubeconfig=kubeconfig.yml apply -f ./.circleci/kube
