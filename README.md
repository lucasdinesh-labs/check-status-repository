# GitHub Actions Status POCs

This repository tests a draft-gate CI dispatcher and GitHub Actions
commit-status behavior.

The workflows are intentionally standalone. They do not clone or use any SAP
application code.

## Merge Queue Unit Tests

`Unit Tests` runs through the CI dispatcher for pull requests and directly for
GitHub's `merge_group` event.
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

## Draft Gate Dispatcher

`CI Dispatcher` is the only workflow triggered by pull-request events. It puts
new or uninitialized pull requests in draft and never dispatches CI while a PR
is draft. When a previously drafted PR becomes ready for review, or receives a
new commit while ready, it calls the reusable CI orchestrator with the current
head SHA.

The dispatcher is serialized per PR and verifies the current API head SHA
before dispatching. This prevents queued stale events from starting CI for an
older commit. Piper, Unit Tests, and Component Tests are reusable workflows,
so they are not individually triggered or skipped for unrelated PR events.

The dispatcher requires a `CI_DISPATCHER_TOKEN` repository secret. GitHub's
default Actions token cannot convert a pull request to draft. Use a fine-grained
token limited to this repository with `Pull requests: Read and write`.
