# happy-server

Container build and publish pipeline for Happy Server.

## Images

The GitHub Actions workflow publishes to GHCR:

- `ghcr.io/cdenneen/happy-server:latest`
- `ghcr.io/cdenneen/happy-server:server-<upstreamShort>-hs-<buildShort>`

`latest` always points to the newest build from upstream `main`.

## Upstream source

Builds use upstream `slopus/happy-server` and pin to the resolved SHA at build time.

## Local build

```sh
docker build -t happy-server:local .
```

## Runtime

The container exposes port `3000` and expects environment variables supplied by the runtime.
