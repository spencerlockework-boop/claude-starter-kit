# Post-It Cheat Sheet

```
┌──────────────────────────────────────────────┐
│   CLAUDE CODE — POST-IT                       │
├──────────────────────────────────────────────┤
│  OPEN PROJECT                                 │
│    cd ~/Documents/Claude-Code-Repos/<repo>    │
│    claude                   (start session)   │
│    claude --resume          (continue last)   │
├──────────────────────────────────────────────┤
│  EVERY SESSION STARTS WITH                    │
│    /new-session    orient (5-line status)     │
├──────────────────────────────────────────────┤
│  WORK LOOP                                    │
│    /plan-feature <name>   break into tasks    │
│    "build X in <file>"    just describe it    │
│    /sync-status           quick status check  │
├──────────────────────────────────────────────┤
│  BEFORE COMMITTING                            │
│    /codex:review   external review (no tokens)│
│    "commit these changes"  I'll write msg     │
├──────────────────────────────────────────────┤
│  WHEN CONTEXT FILLS (70%+)                    │
│    /handoff        save state to memory       │
│    /clear          wipe + keep CLAUDE.md      │
├──────────────────────────────────────────────┤
│  CLEANUP + MAINTENANCE                        │
│    /cleanup        find bloat, dead files     │
│    /audit [scope]  parallel audit agents      │
│    /refresh-docs   sync features + backup     │
├──────────────────────────────────────────────┤
│  OUTSIDE CLAUDE (saves tokens)                │
│    bash scripts/doctor.sh                     │
│    bash scripts/refresh-docs.sh               │
│    bash scripts/sync-features-from-issues.sh  │
│    git status / git log --oneline -5          │
├──────────────────────────────────────────────┤
│  FULL SHEET                                   │
│    ccheat     (opens full reference)          │
│    cat ~/Documents/Claude-Code-Repos/...      │
│        /claude-starter-kit/README.md          │
└──────────────────────────────────────────────┘
```

View: `cat ~/Documents/Claude-Code-Repos/claude-starter-kit/docs/POST-IT.md`
