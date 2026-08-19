#!/bin/sh
set -e

cleanup() {
  if [ ! -z "$CADDY_PID" ] && kill -0 "$CADDY_PID" 2>/dev/null; then
    kill -TERM "$CADDY_PID" 2>/dev/null || true
    wait "$CADDY_PID" 2>/dev/null || true
  fi

  if [ ! -z "$PUMA_PID" ] && kill -0 "$PUMA_PID" 2>/dev/null; then
    kill -TERM "$PUMA_PID" 2>/dev/null || true
    wait "$PUMA_PID" 2>/dev/null || true
  fi

  exit 0
}

trap cleanup TERM INT QUIT

bundle exec puma -C config/puma.rb &
PUMA_PID=$!

SOCKET_WAIT_COUNT=0
SOCKET_WAIT_MAX=60

while [ ! -S "${PUMA_SOCKET}" ]; do
  if [ $SOCKET_WAIT_COUNT -ge $SOCKET_WAIT_MAX ]; then
    echo "ERROR: Puma socket not found after ${SOCKET_WAIT_MAX} seconds" >&2
    kill -TERM "$PUMA_PID" 2>/dev/null || true
    exit 1
  fi

  if ! kill -0 "$PUMA_PID" 2>/dev/null; then
    echo "ERROR: Puma process died during startup" >&2
    exit 1
  fi

  sleep 1
  SOCKET_WAIT_COUNT=$((SOCKET_WAIT_COUNT + 1))
done

HANAMI_WAIT_COUNT=0
HANAMI_WAIT_MAX=60

while true; do
  if [ $HANAMI_WAIT_COUNT -ge $HANAMI_WAIT_MAX ]; then
    echo "ERROR: Hanami not ready after ${HANAMI_WAIT_MAX} seconds" >&2
    kill -TERM "$PUMA_PID" 2>/dev/null || true
    exit 1
  fi

  if curl -sf --max-time 2 --unix-socket "${PUMA_SOCKET}" http://localhost/up >/dev/null 2>&1; then
    break
  fi

  if ! kill -0 "$PUMA_PID" 2>/dev/null; then
    echo "ERROR: Puma process died while waiting for Hanami" >&2
    exit 1
  fi

  sleep 1
  HANAMI_WAIT_COUNT=$((HANAMI_WAIT_COUNT + 1))
done

exec caddy run --config Caddyfile --adapter caddyfile
