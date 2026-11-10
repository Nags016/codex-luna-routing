# codex-luna-routing

Never hit your Codex rate limits again — for free. This repo ships a ready-made `config.toml` + `AGENTS.md` that turns **GPT-5.6 Luna** (the cheapest, fastest model on your plan) into your default Codex lane, and reserves stronger models for escalation only.

Based on the viral routing trick: [the original tweet](https://x.com/alannnfx/status/2103007729992507814).

## What it does

Codex's default model burns your quota fast. This setup flips the default to **Luna low** — the cheapest tier — and adds escalation profiles for when a task actually needs more brainpower. Two files do all the work:

| File | Installed to | Purpose |
|------|-------------|---------|
| `config.toml` | `~/.codex/config.toml` | Routes default work to Luna low; defines escalation profiles |
| `AGENTS.md` | `~/.codex/AGENTS.md` | Forces test-verified work, minimal diffs, budget discipline |

**The trick that makes it work:** cheap models fail more often — unless they're forced to verify their own work. The `AGENTS.md` rules make Codex run your tests and compiler after every change, fix its own failures, and stop when tests go green. That turns a cheap model into a reliable one, so you almost never need to escalate.

**Result:** on a ChatGPT Plus plan, Luna gives roughly 50–280 messages per 5 hours vs ~20–110 for Terra (the usual default). Luna-first routing ≈ **2–3x the free throughput** of a default setup.

## Install

One command:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Nags016/codex-luna-routing/main/install.sh)
```

Or from a cloned copy:

```bash
git clone https://github.com/Nags016/codex-luna-routing.git
cd codex-luna-routing
bash install.sh
```

Requires: Codex CLI installed and logged in (`npm i -g @openai/codex && codex login`).

## Usage

After install, just run Codex normally:

```bash
codex                        # everyday work → Luna low (cheapest, default)
codex --profile luna-med     # multi-file edits, routine implementation
codex --profile luna-high    # complex changes that keep failing at medium
codex --profile luna-max     # Luna at full depth, still cheap tokens
codex --profile terra        # Luna got the judgment wrong → switch tier
codex --profile terra-high   # hardest problems only
```

### When to escalate

Follow the ladder — one step at a time:

1. Task failed at Luna low? → retry at `luna-med`. Failed again? → `luna-high`.
2. Still failing with a **judgment** error (wrong tradeoff, wrong approach)? → `terra`.
3. Genuinely ambiguous, high-stakes problem? → `terra-high`.
4. Never bump model *and* effort at the same time — you lose track of what fixed it.

## Uninstall

```bash
bash uninstall.sh   # restores your backed-up config
```

Or manually: `cp ~/.codex/config.toml.bak ~/.codex/config.toml` (if you had a prior config) and delete `~/.codex/AGENTS.md` if you didn't have one before.

## Notes & honest caveats

- **This is model routing, not a hack.** No stolen credits, no jailbreak — it just spends your plan's allowance on the cheapest model that can do the job.
- Your available models and limits depend on your plan. Check the `/model` picker inside Codex to confirm exact slugs (`gpt-5.6-luna`, `gpt-5.6-terra`).
- Luna at low effort is noticeably weaker on ambiguous work. If you see it looping on fixes, jump straight to `--profile terra` instead of re-rolling Luna.
- The AGENTS.md rules apply globally. If you already have a `~/.codex/AGENTS.md`, the installer will back it up too.

## License

MIT — see [LICENSE](LICENSE).
