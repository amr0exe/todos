FROM node:24-alpine3.22 AS builder

WORKDIR /app

RUN corepack enable && corepack prepare pnpm@latest --activate

COPY package.json pnpm-lock.yaml ./

RUN --mount=type=cache,target=/root/.local/share/pnpm/store pnpm i --frozen-lockfile

COPY . .

ARG VITE_API_BASE_URL
ENV VITE_API_BASE_URL=$VITE_API_BASE_URL

RUN pnpm build


FROM nginx:1.28.0-alpine3.21 AS runner

COPY nginx.conf /etc/nginx/nginx.conf

COPY --chown=nginx:nginx --from=builder /app/dist /usr/share/nginx/html

USER nginx

EXPOSE 80

ENTRYPOINT ["nginx", "-c", "/etc/nginx/nginx.conf"]
CMD ["-g", "daemon off;"]
