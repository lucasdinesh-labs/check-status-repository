# GitHub Actions Check POCs

This repository tests GitHub Actions check-run behavior for a pull request
that adds `SKIP COMPONENT TESTS` after a successful Component Tests run.

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

## Inherited Skip Behavior

When `SKIP COMPONENT TESTS` is present, the status seeder creates a current-SHA
check from the immediately preceding Component Tests result. A preceding green
check produces a green inherited check. Any other preceding result produces a
skipped check.

## Chain Experiment

Commit A: real Component Tests baseline.
Commit B: inherited Component Tests result from Commit A.
Commit C: inherited Component Tests result from Commit B.
Commit D: skip label removed, real Component Tests run resumes.
Commit E: inherited Component Tests result from Commit D.
