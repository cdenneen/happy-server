# Agent Guide (happy-server)

This repo builds and publishes the Happy Server container image.

## Build & Publish

- GitHub Actions builds on `main` and publishes to GHCR:
  - `ghcr.io/cdenneen/happy-server:latest`
  - `ghcr.io/cdenneen/happy-server:server-<upstreamShort>-hs-<buildShort>`

The upstream source is resolved from `slopus/happy-server` `main`.
The workflow pins `UPSTREAM_REF` to the resolved SHA.

## Local Build

```sh
docker build -t happy-server:local .
```

## Notes

- No user-specific config in this repo.
- Container listens on port 3000.
