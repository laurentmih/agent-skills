# General LLM Prompting Best Practices

This document summarizes foundational prompt engineering techniques for large language models, focusing on principles that generalize across different model architectures.

## Core Principles

### Clarity and Directness
LLMs perform best when instructions are explicit and unambiguous.
- Be specific about the desired output format, length, and constraints.
- Use sequential steps (numbered or bulleted lists) when the order of operations or completeness is critical.
- Avoid vague requests. Instead of "Create a dashboard," use "Create an analytics dashboard including X, Y, and Z features, ensuring it is fully-featured and handles edge cases."
- The Golden Rule: If a human with minimal context would be confused by your instructions, the LLM likely will be too.

### Providing Context and Motivation
Explaining the "why" behind an instruction helps the model generalize the requirement and apply it more accurately.
- Instead of a flat constraint (e.g., "Do not use ellipses"), provide the reason (e.g., "The response will be read by a text-to-speech engine that cannot pronounce ellipses, so do not use them").
- Providing the underlying goal allows the model to make better intuitive leaps when the prompt doesn't cover every specific scenario.

### Persona and Role Setting
Assigning a specific role in the system prompt narrows the model's probability space and steers its tone and expertise.
- Example: "You are a senior software engineer specializing in distributed systems" focuses the model on technical precision and architectural best practices.

## Structuring the Prompt

### Use of Delimiters and Tags
Complex prompts that mix instructions, context, and user data can become ambiguous. Using clear delimiters (like XML tags, Markdown headers, or triple quotes) helps the model parse the prompt.
- Wrap different sections in descriptive tags: `<instructions>`, `<context>`, `<examples>`, `<input_data>`.
- Use nesting for hierarchical data (e.g., wrapping multiple documents in a `<documents>` tag, with each document in its own `<doc>` tag).
- This reduces the risk of the model confusing instructions with the data it is supposed to process.

### Prompt Ordering for Long Context
When dealing with large amounts of input data (long-context window), the placement of instructions matters.
- Data First: Place long-form documents or data sources at the top of the prompt.
- Query Last: Place the specific query, final instructions, and output constraints at the end.
- This structure typically improves response quality and ensures the model doesn't "lose" the primary instruction amidst the data.

## Using Examples and Data

### Few-Shot and Multi-Shot Prompting
Examples are the most effective way to steer format, tone, and structure.
- Relevance: Examples should closely mirror the actual task.
- Diversity: Include various cases, including edge cases, to prevent the model from picking up unintended patterns.
- Volume: 3–5 high-quality examples are often sufficient for significant improvement.
- Structure: Wrap examples in clear tags so the model distinguishes them from the actual task.

### Steering Output Style
- Positive Reinforcement: To control verbosity or tone, provide positive examples of the desired style rather than just listing negative constraints (e.g., provide a concise example instead of just saying "be concise").
- Explicit Scope: When an instruction should apply broadly, state the scope explicitly (e.g., "Apply this formatting to every section of the document, not just the first one").

## Advanced Techniques

### Chain-of-Thought (CoT) and Reasoning
For complex, multi-step reasoning tasks, explicitly prompting the model to "think" or "reason" before providing the final answer improves accuracy.
- Instruct the model to break the problem down step-by-step.
- For agentic workflows, encouraging the model to output its reasoning process before calling a tool helps reduce errors and improves transparency.

### Iterative Refinement
Prompting is an empirical process.
- Measure the effect of changes against a consistent set of test cases.
- Analyze failure modes: Determine if the error was due to a lack of context, ambiguous instructions, or a failure in the model's reasoning.
- Refine the prompt specifically to address the observed failure patterns.
