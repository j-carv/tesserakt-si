#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$root"

case "${1-}" in
  --check)
    [ "$#" -eq 1 ] || { echo 'Usage: sync-agents.sh [--check]' >&2; exit 2; }
    diff -r .claude/agents .agents/agents
    diff -r -x graphify .claude/skills .agents/skills
    ;;
  '')
    [ "$#" -eq 0 ] || { echo 'Usage: sync-agents.sh [--check]' >&2; exit 2; }
    mkdir -p .agents/agents .agents/skills
    rsync -a --delete .claude/agents/ .agents/agents/
    rsync -a --delete --exclude '/graphify/' .claude/skills/ .agents/skills/
    ;;
  *) echo 'Usage: sync-agents.sh [--check]' >&2; exit 2 ;;
esac
