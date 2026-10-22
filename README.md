# GitHub Actions Status POCs

This repository tests GitHub Actions commit-status behavior for a pull request
enabled with the `Ready for CI/CD` label.

The workflows are intentionally standalone. They do not clone or use any SAP
application code.

## Merge Queue Unit Tests

`Unit Tests` runs for both pull requests and GitHub's `merge_group` event.
The latter checks GitHub's synthetic merge commit immediately before merging.

The `queue-fixtures/` directory supports a deterministic queue test:

- A PR that adds either `feature-c` or `feature-d` passes independently.
- A synthetic commit containing both files fails the unit test.

This demonstrates why the merge queue must validate the combined changes, not
only each pull request independently.

The `master` branch requires the short `Unit Tests`, `Piper`, and `Component
Tests` contexts. Queue builds rerun only unit tests and publish the latter two
as explicit bypasses.

## Inherited Skip Behavior

When `SKIP COMPONENT TESTS` is present, Component Tests creates a current-SHA
status from the immediately preceding Component Tests result. A preceding green
status produces a green inherited status. Any other preceding result also
publishes a green skipped status, preserving the existing merge behavior.

## Ready For CI/CD

Piper reacts only to `labeled`, `synchronize`, `reopened`, and
`ready_for_review` pull-request events when `Ready for CI/CD` is present. Only
addition of that exact label starts a run for a `labeled` event. Component
Tests runs after a successful Piper workflow run, verifies that the label is
still present, and uses the `Component Tests` commit-status context. It reuses
an existing green status for the same head SHA.
