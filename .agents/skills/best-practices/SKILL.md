---
name: best-practices
description: Provides global engineering guidelines for designing agentic tools, writing LLM prompts, and authoring skills. Trigger this skill whenever the user is performing these tasks to ensure alignment with established best practices.
disable-model-invocation: true
---

# Best Practices Hub

This skill provides access to a set of global engineering guidelines for building effective AI agents and tools.

## Document Index

When the user's goal matches one of the following scenarios, read the corresponding document in the `docs/` folder:

- **Designing or refining an agentic tool**: Read `docs/agent_tool_best_practices.md`.
- **Writing or optimizing LLM prompts**: Read `docs/llm_prompting_best_practices.md`.
- **Creating or refining agent skills**: Read `docs/agent_skill_best_practices.md`.
- **Optimizing agent operations and harness configuration**: Read `docs/claude_code_best_practices.md` (covers session management, `AGENTS.md` setup, and automation).

## Usage Instructions

1. **Map Goal to Guide**: Determine if the current task involves architectural decisions for tools, prompt engineering, or skill authoring.
2. **Fetch Relevant Guide**: Read the corresponding markdown file from the `docs/` folder.
3. **Implement and Refine**: Use the principles in the guide to inform your implementation or critique your current approach.
4. **Self-Critique**: Explicitly compare the final output against the guide's core principles. Verify that specific required patterns (e.g., XML tags in prompts or progressive disclosure in skills) are implemented.
