---
name: delegating-tasks
description: Spawns isolated sub-agents with specialized personas for critical reviews or domain-specific tasks. Use this to obtain a dedicated critic, perform specialized analysis, or isolate complex prompts without polluting the primary session's context.
disable-model-invocation: false
---

# Delegating Tasks

This skill enables the delegation of tasks to isolated sub-agents. Execution occurs in a temporary environment to prevent persona leakage and context pollution, while maintaining workspace access.

## Technical Specification

### Execution Mechanism
- **Script**: `/home/piuser/workspace/.agents/skills/delegate/scripts/invoke.sh`
- **Validation Script**: `/home/piuser/workspace/.agents/skills/delegate/scripts/validate-delegate.sh`
- **Pathing Utility**: `/home/piuser/workspace/.agents/skills/delegate/scripts/absolutize.sh`
- **Persona Store**: `/home/piuser/workspace/.agents/skills/delegate/personas/`
- **Style File**: `/home/piuser/workspace/.agents/skills/delegate/STYLE.md`
- **Examples**: `/home/piuser/workspace/.agents/skills/delegate/EXAMPLES.md`
- **Style Injection**: Global styles are injected automatically by the invocation script.

### Absolute Pathing Requirement
Sub-agents use absolute paths. All files referenced in the task prompt MUST use absolute paths (e.g., `/home/piuser/workspace/...`).

## Operational Workflow

When delegating a task, copy this checklist into your response to track progress:

- [ ] **Step 1: Persona Selection**. Run `ls /home/piuser/workspace/.agents/skills/delegate/personas/`.
    - **Discovery**: For larger libraries, use `grep` or `find` to locate specialized personas.
    - **Lifecycle**: Prefix temporary personas with `tmp_` and delete them after task completion.
- [ ] **Step 2: Persona Alignment**. 
    - Use an existing persona or create a new one in `/home/piuser/workspace/.agents/skills/delegate/personas/`.
    - **Validation**: Use `/home/piuser/workspace/.agents/skills/delegate/personas/persona-template.md` for guidance.
- [ ] **Step 3: Invocation**. 
    - Review `/home/piuser/workspace/.agents/skills/delegate/EXAMPLES.md` for prompt structure guidelines.
    - Construct the prompt in a file in `/home/piuser/workspace/.agents/delegations/`.
    - **Requirement**: Include a "Success Criteria" section and a "Known Assumptions" section. 
    - **Verification**: Define a machine-verifiable method (e.g., a script or a specific format) in the Success Criteria.
    - **Pathing**: Use `/home/piuser/workspace/.agents/skills/delegate/scripts/absolutize.sh [prompt_file]` to ensure all paths are absolute.
    - **Validation**: Execute `/home/piuser/workspace/.agents/skills/delegate/scripts/validate-delegate.sh [persona_path] [prompt_file_path]`.
    - **Execution**: Execute `/home/piuser/workspace/.agents/skills/delegate/scripts/invoke.sh [persona_path] [prompt_file_path]`.
- [ ] **Step 4: Validation & Iteration**. 
    - Execute the verification method defined in the Success Criteria.
    - Refine the prompt and re-invoke if any criterion is not met.
- [ ] **Step 5: Cleanup**. Delete any `tmp_` personas used.

## Failure Recovery
- **Validation Error**: Fix the paths or file content as indicated by `validate-delegate.sh`.
- **Persona Mismatch**: Refine the persona file in `personas/` and re-invoke.
- **Permission Error**: Ensure all files are within the workspace.
