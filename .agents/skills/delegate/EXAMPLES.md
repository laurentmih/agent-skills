# Example Delegation Cycle

## 1. Persona Selection
Persona: `/home/piuser/workspace/pi-lab/.agents/skills/delegate/personas/critic.md`

## 2. Prompt Construction
File: `/home/piuser/workspace/pi-lab/.agents/delegations/audit-example.txt`
Content:
```markdown
# Task: Audit the 'delegate' skill

## Success Criteria
- Provide a score from 0-10.
- List at least 3 specific failures.
- The output must be a valid Markdown report.

## Known Assumptions
- The agent has access to SKILL.md.
```

## 3. Validation & Invocation
```bash
/home/piuser/workspace/pi-lab/.agents/skills/delegate/scripts/absolutize.sh /home/piuser/workspace/pi-lab/.agents/delegations/audit-example.txt
/home/piuser/workspace/pi-lab/.agents/skills/delegate/scripts/validate-delegate.sh /home/piuser/workspace/pi-lab/.agents/skills/delegate/personas/critic.md /home/piuser/workspace/pi-lab/.agents/delegations/audit-example.txt
/home/piuser/workspace/pi-lab/.agents/skills/delegate/scripts/invoke.sh /home/piuser/workspace/pi-lab/.agents/skills/delegate/personas/critic.md /home/piuser/workspace/pi-lab/.agents/delegations/audit-example.txt
```

## 4. Verification
- [x] Score provided? Yes.
- [x] 3 failures listed? Yes.
- [x] Valid Markdown? Yes.
