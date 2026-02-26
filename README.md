# happy-server

Container build and publish pipeline for Happy Server, the relay service used by the Happy clients.

## Images

The GitHub Actions workflow publishes to GHCR:

- `ghcr.io/cdenneen/happy-server:latest`
- `ghcr.io/cdenneen/happy-server:server-<upstreamShort>-hs-<buildShort>`

`latest` always points to the newest build from upstream `main`.

## What is Happy Server?

Happy Server is the self-hosted relay used by Happy clients to coordinate sessions, storage, and updates.
For setup and configuration details, see the Happy Engineering guide:

- https://happy.engineering/docs/guides/self-hosting/

## Upstream source

Builds use upstream `slopus/happy` and pin to the resolved SHA at build time.
Source repo and package path:

- https://github.com/slopus/happy/tree/main/packages/happy-server

## Local build

```sh
docker build -t happy-server:local .
```

## Schema and storage setup

Happy Server requires the database schema to be initialized before it can start cleanly. Run one of the
following migration flows after the container image is built and before you start serving traffic.

### PGlite (embedded, default)

Use the standalone migration command to apply Prisma migrations to the embedded PGlite database.

```sh
docker run --rm \
  -e HANDY_MASTER_SECRET=change-me \
  -e DATA_DIR=/data \
  -e PGLITE_DIR=/data/pglite \
  -v happy-data:/data \
  happy-server:local \
  yarn --cwd packages/happy-server standalone migrate
```

### Postgres (local container or external)

Use Prisma migrate deploy against the Postgres database URL.

```sh
docker run --rm \
  -e HANDY_MASTER_SECRET=change-me \
  -e DATABASE_URL=postgresql://user:pass@host:5432/happy-server \
  happy-server:local \
  yarn --cwd packages/happy-server prisma migrate deploy
```

If you are running Postgres in Docker, use the container hostname in the URL (not localhost).

## Runtime

The container exposes port `3000` and expects environment variables supplied by the runtime.
