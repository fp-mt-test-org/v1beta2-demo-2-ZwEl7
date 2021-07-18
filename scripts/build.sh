#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

brew install jfrog-cli

jfrog_output=$(jfrog config show artifactory 2>&1 || true)
does_not_exist_pattern='does not exist'

echo "jfrog_output:"
echo "${jfrog_output}"
echo 

if [[ ${jfrog_output} =~ ${does_not_exist_pattern} ]]; then
    echo "artifactory doesn't exist, adding ${artifactory_base_url}"

    jfrog c add artifactory \
        --url="${artifactory_base_url}" \
        --user="${artifactory_username}" \
        --access-token="${artifactory_password}" \
        --artifactory-url="${artifactory_base_url}/artifactory" \
        --interactive=false
fi

jfrog rt \
    gradle clean \
    artifactoryPublish -b build.gradle \
    --build-name=v1beta2-demo-2-ZwEl7 \
    --build-number=1 \
    -Pversion=1.1.0
