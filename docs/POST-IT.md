# Post-It Cheat Sheet

```
+----------------------------------------------+
|   CLAUDE CODE -- POST-IT                      |
+----------------------------------------------+
|  OPEN PROJECT                                 |
|    cd <your-project-dir>                      |
|    claude                   (start session)   |
|    claude --resume          (continue last)   |
+----------------------------------------------+
|  EVERY SESSION STARTS WITH                    |
|    /new-session    orient (5-line status)     |
+----------------------------------------------+
|  WORK LOOP                                    |
|    /plan-feature <name>   break into tasks    |
|    "build X in <file>"    just describe it    |
|    /test                  run tests           |
|    /sync-status           quick status check  |
+----------------------------------------------+
|  BEFORE COMMITTING                            |
|    /review         subagent review            |
|    "commit these changes"  I'll write msg     |
+----------------------------------------------+
|  WHEN CONTEXT FILLS (70%+)                    |
|    /handoff        save state to memory       |
|    /clear          wipe + keep CLAUDE.md      |
+----------------------------------------------+
|  CLEANUP + MAINTENANCE                        |
|    /cleanup        find bloat, dead files     |
|    /audit [scope]  parallel audit agents      |
+----------------------------------------------+
|  OUTSIDE CLAUDE (saves tokens)                |
|    bash scripts/doctor.sh                     |
|    bash scripts/refresh-docs.sh               |
|    bash scripts/update-external-skills.sh     |
|    bash scripts/lint-refs.sh                  |
|    git status / git log --oneline -5          |
+----------------------------------------------+
```
