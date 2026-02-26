ARG NODE_VERSION=20
ARG UPSTREAM_REPO=https://github.com/slopus/happy.git
ARG UPSTREAM_REF=main

FROM node:${NODE_VERSION}-bookworm-slim AS source

RUN apt-get update \
  && apt-get install -y git ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /src

ARG UPSTREAM_REPO
ARG UPSTREAM_REF

RUN git clone "$UPSTREAM_REPO" . \
  && git checkout "$UPSTREAM_REF" \
  && git rev-parse HEAD > /src/.upstream_sha

FROM node:${NODE_VERSION}-bookworm-slim AS builder

RUN apt-get update \
  && apt-get install -y python3 ffmpeg make g++ build-essential \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /repo

COPY --from=source /src/package.json /src/yarn.lock ./
COPY --from=source /src/scripts ./scripts
COPY --from=source /src/patches ./patches

RUN mkdir -p packages/happy-app packages/happy-server packages/happy-cli packages/happy-agent packages/happy-wire

COPY --from=source /src/packages/happy-app/package.json packages/happy-app/
COPY --from=source /src/packages/happy-server/package.json packages/happy-server/
COPY --from=source /src/packages/happy-cli/package.json packages/happy-cli/
COPY --from=source /src/packages/happy-agent/package.json packages/happy-agent/
COPY --from=source /src/packages/happy-wire/package.json packages/happy-wire/

COPY --from=source /src/packages/happy-app/patches packages/happy-app/patches
COPY --from=source /src/packages/happy-server/prisma packages/happy-server/prisma
COPY --from=source /src/packages/happy-cli/scripts packages/happy-cli/scripts
COPY --from=source /src/packages/happy-cli/tools packages/happy-cli/tools

RUN corepack enable \
  && SKIP_HAPPY_WIRE_BUILD=1 yarn install --frozen-lockfile --ignore-engines

COPY --from=source /src/packages/happy-wire ./packages/happy-wire
COPY --from=source /src/packages/happy-server ./packages/happy-server

RUN yarn workspace @slopus/happy-wire build
RUN yarn workspace happy-server build

FROM node:${NODE_VERSION}-bookworm-slim AS runner

RUN apt-get update \
  && apt-get install -y python3 ffmpeg \
  && rm -rf /var/lib/apt/lists/*

ENV NODE_ENV=production
WORKDIR /repo

COPY --from=source /src/.upstream_sha ./
COPY --from=builder /repo/node_modules /repo/node_modules
COPY --from=builder /repo/packages/happy-wire /repo/packages/happy-wire
COPY --from=builder /repo/packages/happy-server /repo/packages/happy-server

EXPOSE 3000

CMD ["yarn", "--cwd", "packages/happy-server", "start"]
