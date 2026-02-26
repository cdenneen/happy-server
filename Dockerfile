ARG NODE_VERSION=22
ARG UPSTREAM_REPO=https://github.com/slopus/happy-server.git
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

WORKDIR /app

COPY --from=source /src/package.json /src/yarn.lock ./
COPY --from=source /src/prisma ./prisma

RUN corepack enable \
  && yarn install --frozen-lockfile --ignore-engines

COPY --from=source /src/tsconfig.json /src/vitest.config.ts ./
COPY --from=source /src/sources ./sources

RUN yarn build

FROM node:${NODE_VERSION}-bookworm-slim AS runner

RUN apt-get update \
  && apt-get install -y python3 ffmpeg \
  && rm -rf /var/lib/apt/lists/*

ENV NODE_ENV=production
WORKDIR /app

COPY --from=source /src/.upstream_sha ./
COPY --from=builder /app/tsconfig.json ./tsconfig.json
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/sources ./sources
COPY --from=builder /app/prisma ./prisma

EXPOSE 3000

CMD ["yarn", "start"]
