# Debug

Something is broken. Help figure out why.

Input: $ARGUMENTS (error message, symptom description, or file path)

Steps:
1. If $ARGUMENTS contains an error message, parse it for:
   - File path and line number
   - Error type (runtime, compile, type, network, permission)
   - Stack trace (if present)

2. Check recent changes:
   - `git diff HEAD~3 --name-only` — what files changed recently?
   - `git log --oneline -5` — what was the last thing done?

3. Read the relevant files:
   - The file mentioned in the error (if any)
   - Files changed in recent commits that could be related

4. Narrow down the cause:
   - Is it a regression? (did it work before the recent changes?)
   - Is it a dependency issue? (missing package, wrong version)
   - Is it a config issue? (.env, build config, tsconfig)
   - Is it a type/schema mismatch? (API changed, DB schema drift)

5. Report:
   - **Root cause** (1-2 sentences)
   - **Evidence** (file:line, diff, or command output that confirms it)
   - **Fix** (specific change to make)
   - **Confidence** (high/medium/low — be honest if unsure)

If confidence is low, suggest diagnostic steps to narrow it down further rather than guessing.

Do NOT apply the fix automatically. Present it and wait for approval.
