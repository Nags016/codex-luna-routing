# Global rules for every Codex session

## Budget discipline (top priority)

- You run on a rate-limited plan. Never waste a run: think before you act, read the relevant files before editing, and avoid re-doing finished work.
- Start every task with the simplest approach that could pass the project's named tests.
- If a change fails, escalate ONE control at a time — never model + reasoning effort together.

## Verification is the judge

- After every code change, run the project's test suite and compiler/typechecker yourself.
- Never claim a task is done without green tests or a successful build as evidence.
- If tests fail, diagnose the failure and fix it. Do not rephrase the task or guess.
- Stop as soon as named tests pass. No extra refactoring, no polish beyond the task.

## Escalation ladder

1. Default lane (Luna low): mechanical edits, renames, boilerplate, small scoped changes.
2. If the model under-planned or missed checks → raise reasoning effort one step (low → medium → high), same model.
3. If the model got the judgment or tradeoff wrong → switch model tier (Luna → Terra), same effort.
4. Only for genuinely ambiguous, high-stakes problems → Terra high.
- Report which lane you ran in so the user can escalate deliberately.

## Context hygiene

- Read only the files a task needs; avoid loading unrelated code into context.
- Keep answers and diffs minimal — output tokens cost more than input.
- Do not repeat work already completed earlier in the thread.
