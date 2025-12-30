#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

failures=0

echo "::group::Guardrails (.sln and CPM)"

# 1) Enforce .slnx-only solutions (.sln forbidden)
if find . -type f -name "*.sln" -not -path "./.git/*" -print -quit | grep -q .; then
  echo "ERROR: .sln files are not allowed (use .slnx only). Found:"
  find . -type f -name "*.sln" -not -path "./.git/*" -print
  failures=1
fi

# 2) Enforce Central Package Management (no PackageReference Version=...)
# NuGet CPM disallows specifying Version on PackageReference when CPM is enabled.
if grep -RIn --include='*.csproj' '<PackageReference' . | grep -q 'Version="'; then
  echo "ERROR: PackageReference Version= is not allowed under Central Package Management. Found:"
  grep -RIn --include='*.csproj' '<PackageReference' . | grep 'Version="' || true
  failures=1
fi

echo "::endgroup::"

if [[ "$failures" -ne 0 ]]; then
  exit 1
fi

echo "Guardrails passed."
