#!/usr/bin/env bash
set -euo pipefail

# Each feature is valid independently. Their combination represents an
# integration failure that only the merge queue's synthetic commit can expose.
feature_a=false
feature_b=false

if [[ -f queue-features.txt ]]; then
  grep -qx 'feature-a' queue-features.txt && feature_a=true || true
  grep -qx 'feature-b' queue-features.txt && feature_b=true || true
fi

if [[ "$feature_a" == true && "$feature_b" == true ]]; then
  echo '::error::feature-a and feature-b cannot be merged together'
  exit 1
fi

echo 'Unit tests passed.'
