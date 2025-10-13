#!/bin/bash
set -euo pipefail

DATA_ROOT="/server/pub/hackdiet"
USERS_DIR="$DATA_ROOT/Users"
SESSIONS_DIR="$DATA_ROOT/Sessions"
CLUSTER_DIR="$DATA_ROOT/ClusterSync"

mkdir -p "$USERS_DIR" "$SESSIONS_DIR" "$CLUSTER_DIR"
chown -R www-data:www-data "$DATA_ROOT"

exec "$@"
