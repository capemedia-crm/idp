import os
import boto3

region = os.environ["AWS_REGION"]
prefix = os.environ["SSM_PARAMETER_PREFIX"]
output_file = os.environ.get("OUTPUT_FILE", "/work/keycloak.env")

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
    params.extend(resp.get("Parameters", []))

    next_token = resp.get("NextToken")
    if not next_token:
        break

with open(output_file, "w") as f:
    for p in params:
        key = p["Name"].split("/")[-1]
        value = p["Value"].replace('"', '\\"')
        f.write(f'export {key}="{value}"\n')

print(f"Loaded {len(params)} parameters from {prefix} into {output_file}")
