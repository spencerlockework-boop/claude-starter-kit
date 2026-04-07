# Plan

Create a plan for: $ARGUMENTS

Determine the plan type from the first word of $ARGUMENTS:

---

## `/plan project`

Bootstrap the project's core documentation. Check for each file and create any that are missing:

### `docs/tech.md` — Tech Stack
Work with the user to document:
- Languages, frameworks, versions
- Package manager and build tools
- Database, cache, message queue
- Hosting, CI/CD, infrastructure
- Dev tools (linters, formatters, test runners)
- Environment variables and secrets management

### `docs/architecture.md` — System Design
Work with the user to document:
- High-level system diagram (describe in text or Mermaid)
- Service boundaries and communication patterns
- Data flow (request lifecycle)
- Key constraints and invariants
- Security model (auth, authorization, data access)
- What's explicitly OUT of scope

### `docs/map.md` — Module Map
Work with the user to document:
- Table of modules with status (not started / in progress / complete)
- For each module: what it does, who uses it, DB tables it owns, API routes, files, integration points
- What's explicitly NOT being built (scope boundaries)

For each file, if it already exists, read it and ask: "This exists — want to update it or skip?"

After all three are created/confirmed, suggest: "Project docs ready. Run `/plan feature <name>` to start building."

---

## `/plan feature <name>`

Break a feature into implementation tasks.

1. Read `docs/tech.md`, `docs/architecture.md`, `docs/map.md`, and `CLAUDE.md`
2. Identify dependencies on existing modules
3. Break the feature into atomic tasks:
   - Database/schema changes
   - Shared types
   - API routes
   - Frontend components
   - Tests
4. For each task specify:
   - Which agent: `frontend-builder`, `backend-builder`, `architect`
   - Exact files to create/modify
   - Dependencies on other tasks in this plan
   - Complexity: S (under 1hr) / M (1-3hr) / L (multi-session)
5. Output as a numbered list

Do NOT implement. Wait for approval.

---

## `/plan module <name>`

Write a module spec and add it to `docs/map.md`.

1. Read `docs/tech.md` and `docs/architecture.md` for conventions
2. Read `docs/map.md` for existing modules and naming patterns
3. Write the spec for the new module:
   - What it does (1-2 sentences)
   - Who uses it
   - DB tables (owned by this module)
   - API routes
   - Files to create
   - Integration points with other modules
   - Explicitly NOT building (scope boundaries)
4. Add the module to the status table in `docs/map.md`

---

If $ARGUMENTS doesn't start with `project`, `feature`, or `module`, treat it as a feature name:
`/plan auth flow` = `/plan feature auth flow`
