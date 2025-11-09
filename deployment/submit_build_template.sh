#!/bin/bash
REGION="" # FILL ME IN
PROJECT_ID="" # FILL ME IN


# This makes sure that we are uploading our code from the proper path.
# Don't change this line.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

REPO_NAME="" # FILL ME IN
REGISTRY= "" # FILL ME IN
APP_IMAGE="" # FILL ME IN
TARGET_DOCKERFILE="Dockerfile.${APP_IMAGE}"
SERVING_PORT= # FILL ME IN

# It's not expected to know bash scripting to the level below.
# The following is known as substitutions in cloud build.

REPO_URI="${REGISTRY}/${PROJECT_ID}/${REPO_NAME}"
gcloud builds submit \
    --region=${REGION} \
    --config="${SCRIPT_DIR}/cloudbuild.yaml" \
    --substitutions=_BASE_IMAGE_URI="${REPO_URI}/base_image",_APP_URI="${REPO_URI}/${APP_IMAGE}",_SERVING_PORT=${SERVING_PORT},_TARGET_DOCKERFILE="${TARGET_DOCKERFILE}" \
    ${SCRIPT_DIR}/../
