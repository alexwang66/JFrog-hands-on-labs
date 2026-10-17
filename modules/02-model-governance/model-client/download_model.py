#!/usr/bin/env python3
"""Download a model through a JFrog Hugging Face remote repository."""

import argparse
import os
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
    parser.add_argument("--model", required=True, help="Hugging Face model ID")
    parser.add_argument("--revision", default="main")
    parser.add_argument("--local-dir", default="model_cache")
    parser.add_argument("--dry-run", action="store_true")
    return parser.parse_args()


def main():
    args = parse_args()
    endpoint = os.getenv("HF_ENDPOINT")
    token = os.getenv("JFROG_ACCESS_TOKEN")
    if not endpoint:
        raise SystemExit("HF_ENDPOINT is required and must point to the approved JFrog repository.")
    endpoint = validate_endpoint(endpoint)

    if args.dry_run:
        print(f"endpoint={endpoint}")
        print(f"model={args.model}")
        print(f"revision={args.revision}")
        print(f"local_dir={args.local_dir}")
        print("token_configured=" + ("yes" if token else "no"))
        return

    if not token:
        raise SystemExit("JFROG_ACCESS_TOKEN is required in the process environment.")

    from huggingface_hub import snapshot_download

    path = snapshot_download(
        repo_id=args.model,
        revision=args.revision,
        token=token,
        repo_type="model",
        endpoint=endpoint,
        local_dir=args.local_dir,
    )
    print(f"Downloaded to {path}")


if __name__ == "__main__":
    main()
