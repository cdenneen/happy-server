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

Builds use upstream `slopus/happy-server` and pin to the resolved SHA at build time.
Source repo:

- https://github.com/slopus/happy-server

## Local build

```sh
docker build -t happy-server:local .
```

## Runtime

The container exposes port `3000` and expects environment variables supplied by the runtime.
