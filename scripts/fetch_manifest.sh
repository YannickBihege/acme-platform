#!/usr/bin/env bash
# Placeholder: download manifest.json of the last production run into $1
set -euo pipefail
mkdir -p "$1"
# aws s3 cp s3://<bucket>/dbt-artifacts/manifest.json "$1/manifest.json"
echo "Fetch manifest.json into $1 (see Chapter 14.5)"
