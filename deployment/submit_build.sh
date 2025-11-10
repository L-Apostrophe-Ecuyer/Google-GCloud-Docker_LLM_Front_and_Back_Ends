#!/bin/bash
REGION="us-central1"
PROJECT_ID="hw5-20103530"


# This makes sure that we are uploading our code from the proper path.
# Don't change this line. - THIS BREAKS ON SPACES DID YOU KNOW? I KNOW!! HOW FUN TO KNOW!!!
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ) 


SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/"

REPO_NAME="hw5-images"
REGISTRY="${REGION}-docker.pkg.dev"
APP_IMAGE="backend_v1"  # Ou "frontend_v1", "backend_v2", etc.
TARGET_DOCKERFILE="Dockerfile.${APP_IMAGE}"

# PORT SPÉCIFIQUE PAR APPLICATION
if [[ "$APP_IMAGE" == backend_* ]]; then
    if [[ "$APP_IMAGE" == *v3 ]]; then
        SERVING_PORT=8080  # Backend V3
    else
        SERVING_PORT=8000  # Backend V1 & V2
    fi
else
    SERVING_PORT=8501  # Frontend Streamlit
fi

# It's not expected to know bash scripting to the level below.
# The following is known as substitutions in cloud build.

REPO_URI="${REGISTRY}/${PROJECT_ID}/${REPO_NAME}"
gcloud builds submit \
    --region=${REGION} \
    --config="${SCRIPT_DIR}/cloudbuild.yaml" \
    --substitutions=_BASE_IMAGE_URI="${REPO_URI}/base_image",_APP_URI="${REPO_URI}/${APP_IMAGE}",_SERVING_PORT=${SERVING_PORT},_TARGET_DOCKERFILE="${TARGET_DOCKERFILE}" \
    ${SCRIPT_DIR}/../
