---
name: skill-factory
description: Use this skill whenever the user wants to create, refine, or architect a new agent skill. It provides a structured workflow for building high-utility, low-overhead capabilities.
disable-model-invocation: true
---

# Skill Factory

This skill implements a structured assembly line for building high-utility, low-overhead agent skills.

## MANDATORY FIRST STEP
Before starting any skill design, trigger the `best-practices` skill and read `docs/agent_skill_best_practices.md` to ensure alignment with current engineering standards.

## The Development Loop

Follow these phases in order:

### Phase 1: The Blueprint
Define the "Why" and "How" before writing Markdown.
1. **Goal**: Define the exact capability this skill enables.
2. **The "Pushy" Trigger**: Create a proactive description that triggers the skill based on user intent, not just explicit requests.
3. **Dependencies**: Identify required tools, scripts, or reference docs.
4. **Output**: Define the primary deliverable.

### Phase 2: The Draft
Build the minimum viable skill.
1. **Structure**: Adhere to the Agent Skills standard:
   - `skill-name/SKILL.md` (Frontmatter + Instructions)
   - `skill-name/scripts/` (Deterministic helper code)
   - `skill-name/references/` (Deep-dive docs)
2. **Progressive Disclosure**: Keep the `SKILL.md` body lean. Move detailed reference tables or complex API docs to the `references/` folder.
3. **Imperative Tone**: Use direct, directive language (e.g., "ALWAYS use X", "FORBIDDEN: Y").

### Phase 3: The Lean Check
Ensure the skill is optimized for the system.
- **Frontmatter**: Set `disable-model-invocation: true` for global skills to protect the system prompt's KV cache.
- **Verification**: Confirm placement in the correct directory (`./.agents/skills/` for global, or a local project folder).

### Phase 4: Final Polish
Review the final skill against the `best-practices` guidelines one last time.

---

## Design Principles

- **Principle of Lack of Surprise**: The skill should never perform an action the user did not expect.
- **Developer Velocity**: Favor a "Good Enough" draft that is quickly iterated upon over a "Perfect" draft that takes hours to write.
- **Surgical Edits**: When refining, use the `edit` tool to change specific lines rather than overwriting the whole file.
