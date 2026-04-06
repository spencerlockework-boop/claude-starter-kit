# Bootstrap — Fresh Machine Setup

<!-- TEMPLATE: Replace <placeholders> with your project's actual values. -->

How to get <your-project> running on a new machine from zero.

## 0. Prerequisites

Install these first:
- **Node.js 22+** — https://nodejs.org (or via nvm: `nvm install 22`)
- **pnpm** (or npm/yarn) — `npm install -g pnpm`
- **Docker Desktop** — https://docker.com (if your project uses containers)
- **Git** — usually preinstalled on Mac/Linux
- **gh CLI** — https://cli.github.com (`brew install gh` on Mac)
<!-- Add any project-specific tools below -->
<!-- - **Rust** — `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh` -->
<!-- - **ffmpeg** — `brew install ffmpeg` -->

## 1. Clone the repo

```bash
cd ~/projects  # or wherever you keep repos
git clone https://github.com/<your-org>/<your-repo>.git <your-repo-dir>
cd <your-repo-dir>
```

## 2. Install dependencies

```bash
pnpm install
```

## 3. Create .env

```bash
cp .env.example .env
```

Open `.env` and fill in any required values. For dev, the defaults should work.

## 4. Start infrastructure services (if applicable)

```bash
# docker compose -f <path-to-compose> up -d
```

<!-- TEMPLATE: List what services start (e.g., PostgreSQL, Redis) and their ports. -->

Verify with `docker ps`.

## 5. Apply database migrations (if applicable)

```bash
# pnpm db:migrate
```

## 6. Seed initial data (optional)

```bash
# pnpm db:seed
```

## 7. Verify environment is healthy

```bash
bash scripts/doctor.sh
```

Should report "HEALTHY" or "USABLE". Fix any red items before continuing.

## 8. Start dev servers

```bash
pnpm dev
```

<!-- TEMPLATE: List what starts (e.g., API on port 8080, web on port 3000). -->

## 9. Restore Claude Code memory (optional)

If this is a machine where Claude Code hasn't been used for this project yet:

```bash
bash scripts/restore-memory.sh
```

## 10. Start Claude Code session

```bash
claude
```

Then inside the session:

```
/new-session
```

---

## Troubleshooting

### `pnpm install` fails
- Node version too old? Check with `node --version`, need 22+
- Try: `pnpm install --frozen-lockfile`

### Docker services won't start
- Docker Desktop not running? Start it.
- Port conflict? Check with `lsof -i :<port>`

### Database migrations fail
- Database container not running? Check `docker ps`
- Wrong credentials? Check `DATABASE_URL` in `.env`

### Claude Code memory missing
- Run `bash scripts/restore-memory.sh` to restore from git backup
- Memory files are machine-local at `~/.claude/projects/<slug>/memory/`

---

## One-liner (when everything is installed)

<!-- TEMPLATE: Customize this chain for your project -->
```bash
git clone https://github.com/<your-org>/<your-repo>.git <your-repo-dir> && \
cd <your-repo-dir> && \
pnpm install && \
cp .env.example .env && \
bash scripts/doctor.sh && \
pnpm dev
```
