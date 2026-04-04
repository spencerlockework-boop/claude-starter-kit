# Write Module Spec

<!-- TEMPLATE: Customize the map file path for your project. -->

Write a spec for a new module or feature: $ARGUMENTS

Steps:
1. Read `docs/module-spec-template.md` for the structure
2. Read your project's architecture/map doc for naming conventions and stack decisions
3. Read `CLAUDE.md` for architecture rules
4. Write the spec into your project's map doc under the appropriate module section
5. Include:
   - What it does (1-2 sentences)
   - Who uses it
   - DB tables (owned by which module)
   - API routes
   - Files to create
   - Integration points with other modules
   - Explicitly NOT building (scope boundaries)

If it's a new module, add it to the status table. Keep language spec-oriented, no "v1/v2" or roadmap language.
