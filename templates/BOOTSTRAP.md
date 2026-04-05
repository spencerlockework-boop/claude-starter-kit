# Bootstrap — Fresh Machine Setup

How to get <your-project> running on a new machine from zero.

## 0. Prerequisites

Install these first:
- **Node.js 22+** — https://nodejs.org (or via nvm: `nvm install 22`)
- **pnpm** — `npm install -g pnpm`
- **Docker Desktop** — https://docker.com
- **Git** — usually preinstalled on Mac/Linux
- **gh CLI** — https://cli.github.com (`brew install gh` on Mac)
- **Rust** (for workers) — `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- **ffmpeg** (for media processing) — `brew install ffmpeg` on Mac

## 1. Clone the repo

```bash
cd ~/Documents/Claude-Code-Repos
git clone https://github.com/<your-org>/<your-repo>.git <your-repo-dir>
cd <your-repo-dir>
```

## 2. Install dependencies

```bash
pnpm install
```

This takes a few minutes. Installs API, web, shared, db packages.

## 3. Create .env

```bash
cp .env.example .env
```

Open `.env` and fill in any required values. For dev, the defaults should work.

## 4. Start infrastructure services (Docker)

```bash
docker compose -f infra/compose/docker-compose.yml up -d
```

Starts:
- PostgreSQL (port 5432)
- Redis (port 6379)
- MinIO (ports 9000, 9001)
- Nginx (port 80)

Verify with `docker ps` — you should see 4+ containers running.

## 5. Apply database migrations

```bash
pnpm db:migrate
```

Creates all tables: `assets`, `notifications`, `upload_portals`, `vendors`, etc.

## 6. Seed initial data (optional)

```bash
pnpm db:seed
```

Creates a demo project and a few sample assets.

## 7. Verify environment is healthy

```bash
bash scripts/doctor.sh
```

Should report "HEALTHY" or "USABLE". Fix any red items before continuing.

## 8. Start dev servers

```bash
pnpm dev
```

Starts API (port 8080), web (port 3000), and workers in parallel via Turbo.

Visit http://localhost:3000 — you should see the app.

## 9. Restore Claude Code memory (optional)

If this is a machine where Claude Code hasn't been used for this project yet:

```bash
bash scripts/restore-memory.sh
```

Copies `docs/memory-backup/*.md` → `~/.claude/projects/<slug>/memory/`

## 10. Start Claude Code session

```bash
claude
```

Then inside the session:

```
/new-session
```

Orients you in 5 lines. Ready to work.

---

## Troubleshooting

### `pnpm install` fails
- Node version too old? Check with `node --version`, need 22+
- Try: `pnpm install --frozen-lockfile`

### `docker compose up` fails
- Docker Desktop not running? Start it.
- Port conflict? Check if 5432, 6379, 9000 are already taken: `lsof -i :5432`

### `pnpm db:migrate` fails
- Postgres container not running? Check `docker ps`
- Wrong credentials? Check DATABASE_URL in `.env` matches docker-compose

### API won't start
- Missing `.env`? Run `cp .env.example .env`
- Redis not running? Check `docker ps`
- Run `bash scripts/doctor.sh` for full diagnosis

### Claude Code memory missing
- Run `bash scripts/restore-memory.sh` to restore from git backup
- Memory files are machine-local at `~/.claude/projects/<slug>/memory/`

---

## One-liner (when everything is installed)

```bash
git clone https://github.com/<your-org>/<your-repo>.git <your-repo-dir> && \
cd <your-repo-dir> && \
pnpm install && \
cp .env.example .env && \
docker compose -f infra/compose/docker-compose.yml up -d && \
sleep 10 && \
pnpm db:migrate && \
bash scripts/doctor.sh && \
pnpm dev
```
