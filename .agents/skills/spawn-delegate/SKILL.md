---
name: spawn-delegate
description: Spawns an isolated, ephemeral pi instance to verify commands, test prompts, or run tasks in a clean-room environment without polluting the current workspace or session history.
disable-model-invocation: true
---

# Spawn delegate

Use this skill when you need to "verify in a clean environment," "test a prompt in isolation," or run a task "without the baggage" of the current project.

## Usage

Execute the vanilla instance using the helper script in this skill's directory:
`./scripts/spawn-delegate.sh`

### Interface

| Flag | Description |
| :--- | :--- |
| `--command <msg>` | **Required**. The prompt/command to send to the vanilla instance. |
| `--context-dir <path>` | Execute in `<path>`. Enables context discovery (loads `AGENTS.md` in that folder). |
| `--log` | Enables session logging (removes ephemeral mode). |
| `--system-prompt <text>` | Sets a custom system prompt. |
| `--default-system-prompt` | Uses `pi`'s internal default system prompt. |

## Operational Guidelines

1. **Clean Room Verification**: By default, the instance is isolated with the following constraints:
   - No project context (`-nc`).
   - No session history (`--no-session`).
   - Empty system prompt (`--system-prompt ""`).
   - Runs in a random `/tmp` directory.
2. **Seeding**: To seed the environment, create a directory in `/tmp`, populate it with necessary files/`AGENTS.md`, and pass it via `--context-dir`.
3. **Artifact Inspection**: Check the "Sandbox status" in the output. If the directory was preserved, you can `read` the files in that directory to inspect the output of the vanilla run.
4. **Debugging**: If a run returns a non-zero exit code or output that does not match expectations, re-run with --log

## Example Calls

- **Basic test**: 
  `./scripts/spawn-delegate.sh --command "List files in current directory"`
- **Testing a system prompt**: 
  `./scripts/spawn-delegate.sh --command "Hello" --system-prompt "You are a helpful cat."`
- **Seeded verification**: 
  `./scripts/spawn-delegate.sh --command "Check the config" --context-dir /tmp/seed-config`
