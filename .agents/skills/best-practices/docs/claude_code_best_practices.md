# Best Practices for Agentic Coding Environments

This document summarizes best practices for working with agentic coding tools (like Claude Code), focusing on managing the fundamental constraint of the LLM context window and maximizing the reliability of autonomous actions.

## The Fundamental Constraint: Context Management
LLM performance degrades as the context window fills. Every file read, command output, and message consumes tokens.
- Reset Context: Use `/clear` frequently between unrelated tasks.
- Avoid "Kitchen Sink" Sessions: Do not mix unrelated tasks in one conversation.
- Polluted Context: If an agent fails a task and requires multiple corrections, the context becomes polluted with failed approaches. After two failed attempts, clear the session and start fresh with a more precise prompt incorporating the lessons learned.
- Use Subagents for Exploration: Delegate research/investigation to subagents. They operate in isolated context windows and return only a summary, preventing the main conversation from being bloated by irrelevant file reads.

## Reliability and Verification
Agents can produce "plausible but incorrect" code. Verification is the highest-leverage way to improve results.
- Provide Success Criteria: Instead of "implement X," use "implement X; verify it by running [test command] and ensuring [expected output] is achieved."
- Visual Verification: For UI changes, provide screenshots of the target design and require the agent to take a screenshot of the result to compare and fix differences.
- Root Cause Analysis: When fixing bugs, provide the error message and explicitly instruct the agent to address the root cause rather than suppressing the symptom.

## Operational Workflow: Explore $\rightarrow$ Plan $\rightarrow$ Code
To avoid solving the wrong problem, separate research from execution.
1. Exploration: Use a "Plan Mode" or research phase to read files and understand the system without making changes.
2. Planning: Ask the agent to create a detailed implementation plan. Review and edit this plan before proceeding.
3. Execution: Switch to "Normal Mode" to implement the plan, verifying each step against the success criteria.
4. Finalization: Commit changes with descriptive messages and create pull requests.

## Prompting and Context Provision
- Be Precise: Reference specific files, mention constraints, and point to existing patterns in the codebase (e.g., "Follow the pattern used in `ExampleWidget.ts` to implement `NewWidget.ts`").
- Rich Content: Use file references (`@file`), paste screenshots, or pipe data directly into the agent.
- Interviewing: For large features, have the agent interview you first using a questioning tool to uncover edge cases and tradeoffs before writing a formal specification.

## Environment Configuration
- Persistent Context (`CLAUDE.md`): Use a project-level configuration file for persistent rules (build commands, style guides, repo etiquette).
- Pruning Configuration: Keep configuration files concise. If a rule is already followed by the agent, remove it. Bloated config files can cause the agent to ignore critical instructions.
- Deterministic Hooks: For actions that must happen every time without exception, use hooks (scripts that run automatically) rather than advisory instructions in a config file.
- CLI Tools: Encourage the agent to use existing CLI tools (e.g., `gh`, `aws`) as they are more token-efficient and reliable than raw API calls.

## Scaling and Automation
- Non-Interactive Mode: Use CLI flags (e.g., `claude -p "prompt"`) for integration into CI/CD, pre-commit hooks, or batch processing.
- Parallel Sessions: Run multiple sessions to speed up work or implement "Writer/Reviewer" patterns (one session writes the code, another reviews it in a fresh context to avoid bias).
- Fan-out Patterns: For large-scale migrations, use scripts to loop through files and invoke the agent non-interactively for each file.
