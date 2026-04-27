# Best Practices for Writing Agentic Tools

Based on Anthropic's engineering guide, writing tools for LLM agents requires a shift in mindset: you are creating a contract between a **deterministic system** (the tool) and a **non-deterministic agent** (the LLM).

## 🧠 Core Philosophy
Don't design tools the way you'd design APIs for other developers. Instead, design for the "affordances" of an agent. Agents have limited context windows and can be distracted by too many options or irrelevant data.

## 🛠 Tool Design & Functionality
*   **Avoid "API Wrapping"**: Don't simply wrap every single API endpoint as a tool. Too many overlapping or vague tools can confuse the agent.
*   **Target High-Impact Workflows**: Build a few thoughtful tools that solve specific, real-world tasks rather than a library of generic functions.
*   **Consolidate Operations**: Instead of making the agent chain 5 small tools, create one "high-level" tool that handles a multi-step workflow (e.g., `schedule_event` instead of `check_availability` $\rightarrow$ `book_slot` $\rightarrow$ `send_invite`).
*   **Avoid Brute-Force Tools**: Never provide a tool that returns "everything" (e.g., `list_all_users`) if a targeted tool (e.g., `search_users`) is possible. This prevents wasting the agent's context window.

## 🏷 Naming & Organization
*   **Namespacing**: Group related tools using common prefixes (e.g., `jira_create_issue`, `jira_get_issue`) to help the agent delineate boundaries between different services.
*   **Semantic Naming**: Use natural language and descriptive names. Avoid cryptic abbreviations.
*   **Unambiguous Parameters**: Be explicit with parameter names. Use `user_id` instead of just `user`.

## 📤 Response Optimization (Output)
*   **Maximize Signal-to-Noise**: Return only the information necessary for the agent to take the next step. Strip out technical metadata like UUIDs, mime-types, or internal system IDs unless the agent explicitly needs them for a subsequent tool call.
*   **Use Semantic Identifiers**: If possible, map internal IDs to human-readable names or simple 0-indexed lists to reduce hallucinations.
*   **Controllable Verbosity**: Implement a `response_format` parameter (e.g., `CONCISE` vs `DETAILED`) to allow the agent to decide how much information it needs.
*   **Context Guardrails**: Implement pagination, filtering, and truncation for any tool that could potentially return a large amount of data.
*   **Actionable Errors**: When a tool fails, return a helpful error message that tells the agent *how* to fix the input, rather than a raw stack trace or error code.

## 📝 Tool Definitions (The Spec)
*   **Treat Descriptions as Instructions**: Write tool descriptions as if you are onboarding a new human employee. Explain niche terminology, expected formats, and the relationship between resources.
*   **Iterate via Evaluation**: Tool descriptions are "prompts" for the agent. Small tweaks in wording can lead to dramatic improvements in success rates.

## 🔄 The Development Loop
1.  **Prototype**: Build a quick version of the tool.
2.  **Evaluate**: Create a set of real-world tasks (not simplified sandboxes) and run them through an agentic loop.
3.  **Analyze**: Review the agent's Chain-of-Thought (CoT) and raw transcripts to find where it gets confused.
4.  **Refine**: Update the tool's implementation or description based on the failure modes observed.
