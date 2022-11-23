import json
import tempfile
import urllib.parse

import boto3
from package.PIL import Image, ImageOps

TARGET_S3_BUCKET = "lambda-data-out--apparently-holy-toucan"

s3 = boto3.client("s3")


def upload_file(source, key):
    s3.upload_file(source, TARGET_S3_BUCKET, key)


def get_bucket_and_key(event):
    bucket = event["Records"][0]["s3"]["bucket"]["name"]
    key = urllib.parse.unquote_plus(
        event["Records"][0]["s3"]["object"]["key"], encoding="utf-8"
    )
    return bucket, key


def download_file(bucket, key, target):
    s3.download_file(Bucket=bucket, Key=key, Filename=target)


def invert_image(filepath):
    im = Image.open(filepath).convert("RGB")
    im_invert = ImageOps.invert(im)
    im_invert.save(filepath)


def handler(event, context):
    bucket, key = get_bucket_and_key(event)
    with tempfile.TemporaryDirectory() as tempdir:
        tempfile_path = f"{tempdir}/{key}"
        download_file(bucket, key, tempfile_path)
        invert_image(tempfile_path)
        upload_file(tempfile_path, key)
