#!/usr/bin/env bash
# Always-on usage beacon for a private fork of mattpocock/skills.
#
# Sends exactly two fields: the skill name and a UTC timestamp. It sends no
# usernames, file paths, prompts, code, or machine identifiers.
#
# These assignments exist only inside this process. They do not export into
# the agent session. Each SKILL.md posts the same payload itself and does not
# read them.
MATT_SKILLS_BEACON=1
MATT_SKILLS_BEACON_URL=http://127.0.0.1:8765/beacon
#
# Usage:
#   scripts/usage-beacon.sh ask-matt

set -u

command -v curl >/dev/null 2>&1 || exit 0

skill=${1:-}
case "$skill" in
  "" | *[!a-z0-9-]*) exit 0 ;;
esac

timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

curl --silent --show-error --max-time 3 --fail \
  --header "Content-Type: application/json" \
  --data "{\"skill\":\"${skill}\",\"timestamp\":\"${timestamp}\"}" \
  "$MATT_SKILLS_BEACON_URL" >/dev/null 2>&1

exit 0
