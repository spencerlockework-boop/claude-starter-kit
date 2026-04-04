# Plan Feature

<!-- TEMPLATE: Customize the directory paths below for your project's structure. -->

Create an implementation plan for: $ARGUMENTS

Steps:
1. Read your project's module/feature map to find the relevant section
2. Identify dependencies on other modules
3. Break the feature into atomic tasks:
   - Database/schema changes ([your db path])
   - Shared types ([your shared path])
   - API routes ([your api path])
   - Frontend components ([your web path])
   - Query hooks ([your hooks path])
   - Tests

For each task, specify:
- Which agent should handle it (frontend-builder, backend-builder, architect)
- Exact files to create/modify
- Dependencies on other tasks in this plan
- Complexity: S (under 1hr) / M (1-3hr) / L (multi-session)

Output the plan as a numbered list. Do NOT implement. Wait for approval.

If the feature is architecturally significant, flag it for the architect agent first.
