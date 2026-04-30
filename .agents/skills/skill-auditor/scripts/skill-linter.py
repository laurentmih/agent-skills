#!/usr/bin/env python3
import sys
import os
import re
from pathlib import Path

# --- Configuration ---
FORBIDDEN_PRONOUNS = r'\b(i|me|my|you|your)\b'
VAGUE_ADJECTIVES = ["effectively", "properly", "clearly", "thoroughly", "appropriately"]
CONVERSATIONAL_FLUFF = [
    "it is important to note",
    "please ensure",
    "you should try to",
    "keep in mind"
]
MAX_SKILL_MD_LINES = 500
TOC_THRESHOLD_LINES = 100
MAX_HIERARCHY_DEPTH = 2
TEMPORAL_PATTERN = r'202[0-9]|v\d+\.\d+'

def lint_skill(skill_dir):
    skill_path = Path(skill_dir)
    if not skill_path.is_dir():
        print(f"Error: {skill_dir} is not a directory.")
        sys.exit(1)

    errors = []
    warnings = []

    # 1. Collect files and check hierarchy
    all_files = list(skill_path.rglob('*'))
    for file in all_files:
        if file.is_dir():
            continue
        
        # Rule: Hierarchy depth (Global)
        relative_path = file.relative_to(skill_path)
        depth = len(relative_path.parts) - 1
        if depth > MAX_HIERARCHY_DEPTH:
            errors.append(f"❌ [Hierarchy] File '{relative_path}' is too deep (Level {depth}, Max {MAX_HIERARCHY_DEPTH}).")

    # 2. SKILL.md Specific Checks
    skill_md = skill_path / "SKILL.md"
    if not skill_md.exists():
        errors.append("❌ [Metadata] SKILL.md not found in skill root.")
    else:
        try:
            lines = skill_md.read_text().splitlines()
            
            # Rule: Main file size
            if len(lines) > MAX_SKILL_MD_LINES:
                errors.append(f"❌ [Complexity] SKILL.md exceeds {MAX_SKILL_MD_LINES} lines (Current: {len(lines)}).")

            # Rule: Metadata and Voice
            frontmatter_match = re.match(r'^---\s*\n(.*?)\n---\s*\n', skill_md.read_text(), re.DOTALL)
            if not frontmatter_match:
                errors.append("❌ [Metadata] SKILL.md missing YAML frontmatter.")
            else:
                yaml_content = frontmatter_match.group(1)
                name_match = re.search(r'^name:\s*(.*)$', yaml_content, re.MULTILINE)
                desc_match = re.search(r'^description:\s*(.*)$', yaml_content, re.MULTILINE)
                
                if not name_match:
                    errors.append("❌ [Metadata] SKILL.md frontmatter missing 'name'.")
                if not desc_match:
                    errors.append("❌ [Metadata] SKILL.md frontmatter missing 'description'.")
                else:
                    description = desc_match.group(1).strip().strip('"').strip("'")
                    if re.search(FORBIDDEN_PRONOUNS, description, re.IGNORECASE):
                        errors.append(f"❌ [Voice] Description contains forbidden pronouns: {description}")

        except Exception as e:
            errors.append(f"❌ [Metadata] Failed to analyze SKILL.md: {e}")

    # 3. General Markdown Checks
    for md_file in skill_path.rglob('*.md'):
        try:
            content = md_file.read_text()
            lines = content.splitlines()
            
            # Rule: Pathing (backslashes) - MD only
            if '\\' in content:
                errors.append(f"❌ [Pathing] File '{md_file.relative_to(skill_path)}' contains backslashes (forbidden in documentation).")

            # Rule: TOC requirement
            if len(lines) > TOC_THRESHOLD_LINES:
                header_chunk = "\n".join(lines[:50])
                has_toc_text = "Table of Contents" in header_chunk
                has_internal_links = re.search(r'\[.*?\]\(#.*?\)', header_chunk)
                if not (has_toc_text or has_internal_links):
                    errors.append(f"❌ [Documentation] File '{md_file.relative_to(skill_path)}' exceeds {TOC_THRESHOLD_LINES} lines but missing Table of Contents.")

            # Rule: Stability (Temporal patterns)
            if re.search(TEMPORAL_PATTERN, content):
                errors.append(f"❌ [Stability] File '{md_file.relative_to(skill_path)}' contains temporal patterns (dates/versions).")

        except Exception as e:
            errors.append(f"❌ [Documentation] Failed to analyze {md_file.relative_to(skill_path)}: {e}")

    # 4. Warnings (Vague adjectives and Fluff) - MD only
    for md_file in skill_path.rglob('*.md'):
        try:
            content = md_file.read_text(errors='ignore')
            relative_path = md_file.relative_to(skill_path)
            
            for adj in VAGUE_ADJECTIVES:
                if re.search(rf'\b{adj}\b', content, re.IGNORECASE):
                    warnings.append(f"⚠️ WARNING: Vague adjective '{adj}' found in {relative_path}")
            
            for fluff in CONVERSATIONAL_FLUFF:
                if fluff.lower() in content.lower():
                    warnings.append(f"⚠️ WARNING: Conversational fluff '{fluff}' found in {relative_path}")
        except Exception:
            pass

    # Output Results
    if errors:
        violated_rules = set()
        for err in errors:
            print(err)
            # Extract rule name from brackets [RuleName]
            match = re.search(r'\[(.*?)\]', err)
            if match:
                violated_rules.add(match.group(1))
        
        if warnings:
            print("\n--- Warnings ---")
            for warn in warnings:
                print(warn)
        
        rules_str = ", ".join(sorted(violated_rules))
        print(f"\nRESULT: FAIL - Violated rules: [{rules_str}]")
        return 1
    else:
        if warnings:
            print("\n--- Warnings ---")
            for warn in warnings:
                print(warn)
        print("\nRESULT: PASS")
        return 0

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: skill-linter.py <skill_dir>")
        sys.exit(1)
    
    sys.exit(lint_skill(sys.argv[1]))
