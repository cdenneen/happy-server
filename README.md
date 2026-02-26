# happy-server

Self-hosted server for [happy.engineering](https://happy.engineering), packaged as a Docker image and published to GitHub Container Registry (ghcr.io).

## Usage

### Run with Docker

```bash
docker run -p 3000:3000 ghcr.io/cdenneen/happy-server:latest
```

### Environment Variables

| Variable | Default     | Description              |
|----------|-------------|--------------------------|
| `PORT`   | `3000`      | Port the server listens on |
| `HOST`   | `0.0.0.0`   | Host the server binds to  |

## Development

```bash
node server.js
```

Then open [http://localhost:3000](http://localhost:3000).

