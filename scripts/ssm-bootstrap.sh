#!/usr/bin/env bash
set -euo pipefail

echo "Fetching SSM parameters..."

export PYTHONPATH=/opt/python

python3 <<EOF
import os
import boto3

region = os.environ["AWS_REGION"]
prefix = os.environ["SSM_PARAMETER_PREFIX"]

ssm = boto3.client("ssm", region_name=region)

params = []
next_token = None

while True:
    kwargs = {
        "Path": prefix,
        "Recursive": True,
        "WithDecryption": True,
    }
    if next_token:
        kwargs["NextToken"] = next_token

    resp = ssm.get_parameters_by_path(**kwargs)
    params.extend(resp["Parameters"])

    next_token = resp.get("NextToken")
    if not next_token:
        break

for p in params:
    key = p["Name"].split("/")[-1]
    value = p["Value"]
    os.environ[key] = value
    print(f"Loaded {key}")

# Exec Keycloak
os.execv("/opt/keycloak/bin/kc.sh", ["kc.sh", "start"])
EOF