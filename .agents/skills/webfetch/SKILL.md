---
name: webfetch
description: Fetches static web pages and extracts the primary content into a cleaned, semantic text format, removing noise like ads, navbars, and footers. Use when the user provides a URL and needs to read the page content without HTML cruft.
disable-model-invocation: true
---

# WebFetch

A utility for extracting the "meat" of a webpage for LLM consumption.

## Execution Requirement

**CRITICAL: Do NOT run this script using `python3`.** 
The script is configured with a localized virtual environment via its shebang. Running it with `python3` will bypass the environment and cause a `ModuleNotFoundError`.

Execute the script directly as a binary:

```bash
.agents/skills/webfetch/webfetch.py <url>
```


## Implementation Details
- **Fetch Engine**: Uses `trafilatura` to isolate main content.
- **Output**: 
    - `stdout`: The cleaned, semantic text of the page.
    - `stderr`: Performance metrics (original size, extracted size, and noise reduction ratio).
- **Constraint**: This is a static fetcher. It does not execute JavaScript (no SPA support).

## Troubleshooting
- If the tool returns an error for a specific URL, it may be due to bot detection (403 Forbidden) or the page being a Single Page Application (SPA) that requires JS rendering.
