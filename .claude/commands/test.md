# Run Tests

Run the project's test suite and summarize results.

Steps:
1. Read CLAUDE.md to find the test command (look for test scripts, `pnpm test`, `npm test`, `pytest`, `cargo test`, etc.)
2. If no test command is documented, check `package.json` scripts, `Makefile`, or common test runners
3. Run the test command
4. Summarize results:
   - Total tests: passed / failed / skipped
   - Failed test names and one-line reason for each failure
   - If all pass: just say "All tests pass" with the count

If $ARGUMENTS is provided, scope to that test file or pattern.

Keep output under 15 lines. Don't explain what tests do — just report pass/fail.
