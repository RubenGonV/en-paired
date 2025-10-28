import os
import boto3
import pytest

# Variables mínimas (puedes usar env vars en CI/CD)
AWS_REGION = os.getenv("AWS_DEFAULT_REGION", "eu-west-1")

# Nombre del bucket que Terraform creó
# Puedes pasar el nombre por env var o hardcodearlo para test
S3_BUCKET_NAME = os.getenv("S3_BUCKET_NAME")

@pytest.mark.skipif(S3_BUCKET_NAME is None, reason="S3_BUCKET_NAME not set")
def test_s3_bucket_exists():
    s3 = boto3.client("s3", region_name=AWS_REGION)
    response = s3.list_buckets()
    buckets = [b["Name"] for b in response["Buckets"]]
    assert S3_BUCKET_NAME in buckets, f"{S3_BUCKET_NAME} does not exist in AWS"
