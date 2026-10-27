#!/bin/bash
set -euo pipefail
VERSION="${1:?usage: bump-version.sh <version>}"
sed -i -E "s/^version: .*/version: ${VERSION}+$(date +%s | cut -c4-10)/" pubspec.yaml
git add pubspec.yaml
