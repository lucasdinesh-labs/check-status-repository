#!/usr/bin/env bash
set -euo pipefail

# Each feature is valid independently. Their combination represents an
# integration failure that only the merge queue's synthetic commit can expose.
# Separate files keep the fixture PRs mergeable.
if [[ -f queue-fixtures/feature-c && -f queue-fixtures/feature-d ]]; then
  echo '::error::feature-c and feature-d cannot be merged together'
  exit 1
fi

if [[ -f queue-fixtures/feature-e && -f queue-fixtures/feature-f ]]; then
  echo '::error::feature-e and feature-f cannot be merged together'
  exit 1
fi

echo 'Unit tests passed.'
