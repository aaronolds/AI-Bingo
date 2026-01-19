# Stories

This folder contains GitHub-ready user stories in Markdown.

## Conventions
- File naming: `epic-<n>-story-<n>-<slug>.md`
- Format: **User Story**, **Scope**, **Acceptance Criteria**, **Implementation Tasks**, **Notes/Dependencies**

## How to publish to GitHub Issues (optional)
Use the helper script to create one GitHub Issue per story file:

- Dry-run: `./scripts/create_github_issues_from_stories.sh --dry-run`
- Create issues: `./scripts/create_github_issues_from_stories.sh --apply`
- Include Epic 0–1 too: `./scripts/create_github_issues_from_stories.sh --apply --all-epics`

By default it publishes `stories/epic-[2-6]-story-*.md` and skips the placeholder file.
