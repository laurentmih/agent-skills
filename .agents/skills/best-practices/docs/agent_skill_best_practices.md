# Best Practices for Authoring Agent Skills

This document outlines how to create "Skills"—specialized sets of instructions, reference materials, and utility scripts—that enable an agent to perform complex, domain-specific tasks reliably.

## Core Principles

### Token Efficiency and Conciseness
The agent's context window is a shared and limited resource.
- Assume the agent is already highly capable. Do not explain basic concepts (e.g., do not explain what a PDF is).
- Only provide information the agent does not already have.
- Every token in a skill competes with conversation history and the user's request.

### Calibrating Degrees of Freedom
Match the specificity of instructions to the risk and variability of the task.
- High Freedom (General Guidelines): Use when multiple valid approaches exist or decisions depend heavily on context (e.g., a code review process).
- Medium Freedom (Templates/Pseudocode): Use when a preferred pattern exists but some variation is acceptable.
- Low Freedom (Exact Commands): Use when operations are fragile, error-prone, or require absolute consistency (e.g., database migrations). Provide exact scripts and forbid modifications.

## Skill Structure and Discovery

### Metadata and Naming
- Naming: Use consistent, descriptive names. The gerund form (e.g., `processing-pdfs`, `analyzing-logs`) clearly describes the capability.
- Descriptions: The description is the primary mechanism for skill discovery.
    - Write in the third person.
    - Be specific: Include both what the skill does and the specific triggers/contexts for when it should be used.
    - Avoid vague descriptions like "helps with documents."

### Progressive Disclosure (Information Architecture)
To prevent context bloat, use a hierarchical structure where the agent loads detailed information only when needed.
- Main Entry Point: Keep the primary skill file concise (ideally under 500 lines). It should act as a table of contents.
- Reference Files: Move detailed API docs, examples, and guides into separate files.
- Shallow Hierarchy: Keep references one level deep from the main file to ensure the agent can find and read them reliably.
- Domain Organization: Group reference files into folders by domain (e.g., `reference/finance.md`, `reference/sales.md`) to avoid loading irrelevant context.
- Table of Contents: Include a TOC at the top of any reference file longer than 100 lines.

## Workflow and Quality Control

### Complex Task Management
- Sequential Workflows: Break complex operations into clear, numbered steps.
- Checklists: Provide a checklist that the agent can copy into its response to track progress. This prevents the agent from skipping critical validation steps.
- Feedback Loops: Implement "Validator $\rightarrow$ Fix $\rightarrow$ Repeat" patterns. Require the agent to run a validation script and fix all errors before proceeding to the next step.

### Output Consistency
- Template Pattern: Provide exact templates for required output formats (e.g., for API responses) or flexible guidelines for open-ended reports.
- Example Pattern: Provide input/output pairs to demonstrate the desired style, level of detail, and formatting.

## Executable Code and Utility Scripts

### Robust Scripting
- Solve, Don't Punt: Scripts should handle errors explicitly. Do not let a script fail with a raw error and expect the agent to "figure it out."
- Eliminate Magic Numbers: Justify all constants and configuration parameters in comments so the agent understands the reasoning.
- Prefer Utility Scripts: Provide pre-written scripts for deterministic operations rather than asking the agent to generate code on the fly. This increases reliability and saves tokens.

### High-Stakes Operations
- Plan-Validate-Execute: For batch operations or destructive changes, enforce a workflow where the agent:
    1. Creates a structured plan (e.g., a `changes.json` file).
    2. Validates the plan with a script.
    3. Executes the changes only after validation passes.
- Verifiable Outputs: Create intermediate files that can be machine-verified.

## Development and Iteration

### Evaluation-Driven Development
Do not write extensive documentation based on assumptions. Use an empirical loop:
1. Identify Gaps: Observe where the agent fails without the skill.
2. Create Evaluations: Build specific scenarios that test those failures.
3. Build Minimally: Write just enough instruction to pass the evaluations.
4. Iterate: Refine based on observed agent behavior.

### The "A/B" Development Pattern
Use two separate agent instances for development:
- Agent A (The Architect): Used to design, refine, and organize the skill instructions.
- Agent B (The Tester): A fresh instance that uses the skill to perform real tasks.
- Feedback Loop: Observe Agent B's failures and bring those specific insights back to Agent A for refinement.

## Technical Constraints
- Pathing: Always use forward slashes (`/`) for file paths to ensure cross-platform compatibility.
- Time-Sensitivity: Avoid dates or version-specific instructions that will expire. Use an "Old Patterns" or "Legacy" section for deprecated information.
- Terminology: Maintain strict consistency in terminology throughout the skill (e.g., do not mix "endpoint," "URL," and "route").
