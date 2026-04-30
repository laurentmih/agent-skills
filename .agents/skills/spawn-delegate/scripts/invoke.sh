#!/bin/bash
# /home/piuser/workspace/.agents/skills/delegate/scripts/invoke.sh

PERSONA_FILE=$1
PROMPT_INPUT=$2

WORKSPACE_ROOT="/home/piuser/workspace"
STYLE_FILE="$WORKSPACE_ROOT/.agents/skills/delegate/STYLE.md"

if [ ! -f "$PERSONA_FILE" ]; then
    echo "Error: Persona file not found at $PERSONA_FILE" >&2
    exit 1
fi

# Determine if PROMPT_INPUT is a file path or direct text
if [ -f "$PROMPT_INPUT" ]; then
    PROMPT_CONTENT=$(cat "$PROMPT_INPUT")
else
    PROMPT_CONTENT="$PROMPT_INPUT"
fi

# Load content
STYLE_CONTENT=$(cat "$STYLE_FILE")

# Combine everything: Style -> Persona -> Prompt
FULL_PROMPT="## GLOBAL STYLE CONSTRAINTS
${STYLE_CONTENT}

## PERSONA
$(cat "$PERSONA_FILE")

## TASK
${PROMPT_CONTENT}"

VOID_DIR="/tmp/pi-delegate-$(date +%s)"
mkdir -p "$VOID_DIR"

cd "$VOID_DIR" && pi -p "$FULL_PROMPT"

# Cleanup
rm -rf "$VOID_DIR"
