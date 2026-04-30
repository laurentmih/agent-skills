#!/bin/bash
# absolutize.sh: Converts relative paths in a file to absolute paths.
# Only converts paths that look like they are within the workspace.

INPUT_FILE=$1
WORKSPACE_ROOT="/home/piuser/workspace/pi-lab"

if [ -z "$INPUT_FILE" ] || [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Valid input file required."
    echo "Usage: ./absolutize.sh [prompt_file]"
    exit 1
fi

# Use sed to replace paths that start with ./ or ../ or are just relative to workspace
# This is a simplified version. We'll focus on common relative patterns.

# Convert ./path to /home/piuser/workspace/pi-lab/path
sed -i "s|\./|$WORKSPACE_ROOT/|g" "$INPUT_FILE"

# Convert ../.agents/ to /home/piuser/workspace/pi-lab/.agents/ (assuming 1 level up from a skill dir)
# This is tricky because we don't know where we are. 
# But since most skills are in .agents/skills/X, ../ is usually .agents/skills/
# Better approach: search for known relative roots.
sed -i "s|\.\./\.agents/|$WORKSPACE_ROOT/.agents/|g" "$INPUT_FILE"

# Find any other patterns that look like paths but don't start with / and are not in /tmp or /dev
# and are likely in the workspace.
# This is complex for a bash script. Let's stick to the most common ones for now.

echo "Absolute path conversion attempted on $INPUT_FILE."
