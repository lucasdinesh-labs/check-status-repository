# Workflow Run Check POC

This repository tests GitHub Actions check-run behavior for a pull request
that adds `SKIP COMPONENT TESTS` after a successful Component Tests run.

The workflows are intentionally standalone. They do not clone or use any SAP
application code.

## Inherited Skip Behavior

When `SKIP COMPONENT TESTS` is present, the status seeder creates a current-SHA
check from the immediately preceding Component Tests result. A preceding green
check produces a green inherited check. Any other preceding result produces a
skipped check.

## Chain Experiment

Commit A: real Component Tests baseline.
Commit B: inherited Component Tests result from Commit A.
