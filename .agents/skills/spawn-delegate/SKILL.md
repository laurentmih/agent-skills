---
name: spawn-delegate
description: Spawns an isolated, ephemeral pi instance to verify commands, test prompts, or run tasks in a clean-room environment without polluting the current workspace or session history.
disable-model-invocation: true
---

# Vanilla Pi

Use this skill when you need to "verify in a clean environment," "test a prompt in isolation," or run a task "without the baggage" of the current project.

## Usage

Execute the vanilla instance using the helper script:
`.agents/skills/vanilla-pi/scripts/vanilla-pi.sh`

### Interface

| Flag | Description |
| :--- | :--- |
| `--command <msg>` | **Required**. The prompt/command to send to the vanilla instance. |
| `--context-dir <path>` | Execute in `<path>`. Enables context discovery (loads `AGENTS.md` in that folder). |
| `--log` | Enables session logging (removes ephemeral mode). |
| `--system-prompt <text>` | Sets a custom system prompt. |
| `--default-system-prompt` | Uses `pi`'s internal default system prompt. |

## Operational Guidelines

1. **Clean Room Verification**: By default, the instance is maximally isolated:
   - No project context (`-nc`).
   - No session history (`--no-session`).
   - Empty system prompt (`--system-prompt ""`).
   - Runs in a random `/tmp` directory.
2. **Seeding**: To seed the environment, create a directory in `/tmp`, populate it with necessary files/`AGENTS.md`, and pass it via `--context-dir`.
3. **Artifact Inspection**: Check the "Sandbox status" in the output. If the directory was preserved, you can `read` the files in that directory to inspect the output of the vanilla run.
4. **Debugging**: If a run fails mysteriously, re-run with `--log` to inspect the session later via `pi -r`.

## Example Calls

- **Basic test**: 
  `.agents/skills/vanilla-pi/scripts/vanilla-pi.sh --command "List files in current directory"`
- **Testing a system prompt**: 
  `.agents/skills/vanilla-pi/scripts/vanilla-pi.sh --command "Hello" --system-prompt "You are a helpful cat."`
- **Seeded verification**: 
  `.agents/skills/vanilla-pi/scripts/vanilla-pi.sh --command "Check the config" --context-dir /tmp/seed-config`
