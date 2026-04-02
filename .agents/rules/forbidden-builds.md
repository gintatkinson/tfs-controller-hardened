---
trigger: always_on
---

Before executing any deployment, compilation, or shell scripting command, you MUST explicitly output a checklist cross-referencing the target code against every rule listed in _agents/skills/. You are FORBIDDEN from running commands until the code is statically verified to comply with those skills, and you must request explicit user approval before proceeding