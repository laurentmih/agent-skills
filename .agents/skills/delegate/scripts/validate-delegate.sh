#!/bin/bash
# validate-delegate.sh: Pre-flight check for the delegate skill.

PERSONA_PATH=$1
PROMPT_PATH=$2

if [ -z "$PERSONA_PATH" ] || [ -z "$PROMPT_PATH" ]; then
    echo "Error: Missing arguments."
    echo "Usage: ./validate-delegate.sh [persona_path] [prompt_file_path]"
    exit 1
fi

if [ ! -f "$PERSONA_PATH" ]; then
    echo "Error: Persona file not found at $PERSONA_PATH"
    exit 1
fi

if [ ! -f "$PROMPT_PATH" ]; then
    echo "Error: Prompt file not found at $PROMPT_PATH"
    exit 1
fi

# Check if paths are absolute
if [[ "$PERSONA_PATH" != /home/piuser/workspace/pi-lab/* ]]; then
    echo "Error: Persona path must be absolute and within the workspace."
    exit 1
fi

if [[ "$PROMPT_PATH" != /home/piuser/workspace/pi-lab/* ]]; then
    echo "Error: Prompt path must be absolute and within the workspace."
    exit 1
fi

# Validate Prompt Content
PROMPT_CONTENT=$(cat "$PROMPT_PATH")

if ! echo "$PROMPT_CONTENT" | grep -q "Success Criteria"; then
    echo "Error: Prompt is missing 'Success Criteria' section."
    exit 1
fi

if ! echo "$PROMPT_CONTENT" | grep -q "Known Assumptions"; then
    echo "Error: Prompt is missing 'Known Assumptions' section."
    exit 1
fi

# Check for relative paths within the prompt
# This looks for patterns that look like paths (containing /) but don't start with /
# We exclude common score patterns like (X/10) or 8/10.
RELATIVE_PATHS=$(grep -oE '[^ ]+/[^ ]+' "$PROMPT_PATH" | grep -v '^/' | grep -vE '^[0-9X/()]+$')

if [ -n "$RELATIVE_PATHS" ]; then
    echo "Error: Relative paths detected in prompt. All paths must be absolute."
    echo "Offending paths:"
    echo "$RELATIVE_PATHS"
    exit 1
fi

echo "Pre-flight check passed."
exit 0
