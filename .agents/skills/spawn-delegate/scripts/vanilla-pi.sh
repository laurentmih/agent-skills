#!/bin/bash

# vanilla-pi.sh - Spawn an isolated, ephemeral pi instance.

# Defaults and State
SESSIONS_LOGGING=false
CONTEXT_DISCOVERY=false
USE_DEFAULT_PROMPT=false
SYSTEM_PROMPT=""
CREATED_BY_SCRIPT=false
WORK_DIR=""
COMMAND=""

# Parse flags
while [[ $# -gt 0 ]]; do
  case $1 in
    --command)
      COMMAND="$2"
      shift 2
      ;;
    --context-dir)
      WORK_DIR="$2"
      CONTEXT_DISCOVERY=true
      shift 2
      ;;
    --log)
      SESSIONS_LOGGING=true
      shift
      ;;
    --system-prompt)
      SYSTEM_PROMPT="$2"
      shift 2
      ;;
    --default-system-prompt)
      USE_DEFAULT_PROMPT=true
      shift
      ;;
    *)
      echo "Unknown flag: $1"
      exit 1
      ;;
  esac
done

# Validation
if [[ -z "$COMMAND" ]]; then
  echo "Error: --command is required."
  exit 1
fi

# Directory Setup
if [[ -z "$WORK_DIR" ]]; then
  WORK_DIR=$(mktemp -d /tmp/pi-vanilla.XXXXXX)
  CREATED_BY_SCRIPT=true
else
  mkdir -p "$WORK_DIR"
fi
cd "$WORK_DIR" || exit 1

# Build arguments array to prevent injection and quoting issues
ARGS=("-p")

# Context flag
if [[ "$CONTEXT_DISCOVERY" == false ]]; then
  ARGS+=("-nc")
fi

# Session flag
if [[ "$SESSIONS_LOGGING" == false ]]; then
  ARGS+=("--no-session")
fi

# System prompt flag
if [[ "$USE_DEFAULT_PROMPT" == false ]]; then
  # Even if SYSTEM_PROMPT is empty, we pass it to override default
  ARGS+=("--system-prompt" "$SYSTEM_PROMPT")
fi

# Execute pi
# We pass the array and the final command
pi "${ARGS[@]}" "$COMMAND"

# Cleanup
if [[ "$CREATED_BY_SCRIPT" == true ]]; then
  if [[ -z $(ls -A "$WORK_DIR") ]]; then
    rm -rf "$WORK_DIR"
    DIR_STATUS="deleted (empty)"
  else
    DIR_STATUS="preserved at $WORK_DIR"
  fi
else
  DIR_STATUS="used $WORK_DIR"
fi

echo "--------------------------------------------------------------------------------"
echo "Sandbox status: $DIR_STATUS"
