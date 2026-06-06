#!/bin/bash
set -euo pipefail

DATA_ROOT="/server/pub/hackdiet"

# Recreate every data subdirectory the application writes to. This matters for
# bind mounts, which (unlike named/anonymous volumes) do NOT inherit the dirs
# seeded into the image, so they must be (re)created on every start.
mkdir -p \
    "$DATA_ROOT/Users" \
    "$DATA_ROOT/Sessions" \
    "$DATA_ROOT/RememberMe" \
    "$DATA_ROOT/ClusterSync" \
    "$DATA_ROOT/Pubname" \
    "$DATA_ROOT/Invitations" \
    "$DATA_ROOT/Backups"
chown -R www-data:www-data "$DATA_ROOT"

exec "$@"
