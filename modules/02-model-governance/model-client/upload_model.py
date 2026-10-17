#!/usr/bin/env python3
"""Upload an instructor-approved model folder to a JFrog Hugging Face endpoint."""

import argparse
import os
from pathlib import Path
from urllib.parse import urlparse


APPROVED_HF_HOST = "alexwangtrial.jfrog.io"
APPROVED_HF_PATH = "/artifactory/api/huggingfaceml/workshop-huggingfaceml"


def validate_endpoint(endpoint):
    parsed = urlparse(endpoint)
    if (
        parsed.scheme != "https"
        or parsed.hostname != APPROVED_HF_HOST
        or parsed.path.rstrip("/") != APPROVED_HF_PATH
        or parsed.username
        or parsed.password
        or parsed.query
        or parsed.fragment
    ):
        raise SystemExit(
            "HF_ENDPOINT must point to the approved workshop-huggingfaceml JFrog endpoint."
        )
    return endpoint.rstrip("/")


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", required=True, help="Approved local model folder")
    parser.add_argument("--repo-id", required=True, help="Destination model ID")
    parser.add_argument("--revision", default="main")
    parser.add_argument("--dry-run", action="store_true")
    return parser.parse_args()


def main():
    args = parse_args()
    endpoint = os.getenv("HF_ENDPOINT")
    token = os.getenv("JFROG_ACCESS_TOKEN")
    source = Path(args.source).expanduser().resolve()
    if not endpoint:
        raise SystemExit("HF_ENDPOINT is required and must point to the approved JFrog repository.")
    endpoint = validate_endpoint(endpoint)
    if not source.is_dir():
        raise SystemExit(f"Source folder does not exist: {source}")

    if args.dry_run:
        print(f"endpoint={endpoint}")
        print(f"source={source}")
        print(f"repo_id={args.repo_id}")
        print(f"revision={args.revision}")
        print("token_configured=" + ("yes" if token else "no"))
        return

    if not token:
        raise SystemExit("JFROG_ACCESS_TOKEN is required in the process environment.")

    from huggingface_hub import HfApi

    api = HfApi(endpoint=endpoint, token=token)
    api.upload_folder(
        folder_path=str(source),
        repo_id=args.repo_id,
        revision=args.revision,
        repo_type="model",
    )
    print("Upload completed")


if __name__ == "__main__":
    main()
