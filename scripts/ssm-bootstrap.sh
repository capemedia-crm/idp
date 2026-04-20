#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${AWS_REGION:-}" ]]; then
  echo "AWS_REGION is required"
  exit 1
fi

if [[ -z "${SSM_PARAMETER_PREFIX:-}" ]]; then
  echo "SSM_PARAMETER_PREFIX is required"
  exit 1
fi

echo "Loading Keycloak configuration from SSM prefix: ${SSM_PARAMETER_PREFIX}"

PARAMS_JSON=$(
  aws ssm get-parameters-by-path \
    --region "${AWS_REGION}" \
    --path "${SSM_PARAMETER_PREFIX}" \
    --with-decryption \
    --recursive \
    --output json
)

echo "${PARAMS_JSON}" | jq -r '
  .Parameters[]
  | "\(.Name)=\(.Value)"
' | while IFS='=' read -r full_name value; do
    key="${full_name##*/}"
    export "${key}=${value}"
    echo "Exported ${key}"
done

exec /opt/keycloak/bin/kc.sh start