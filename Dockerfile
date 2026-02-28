# 1) Dependencies stage
FROM node:20-alpine AS deps
WORKDIR /app

COPY package*.json ./
RUN npm ci

# 2) Build stage (nếu bạn có build: TypeScript / bundling)
FROM node:20-alpine AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
# Nếu không có build thì bạn có thể bỏ dòng này
# RUN npm run build

# 3) Runtime stage (nhẹ nhất)
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

# Tạo user không phải root
RUN addgroup -S app && adduser -S app -G app

# Copy đúng thứ cần để chạy
COPY --from=build /app/package*.json ./
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/. .

# Nếu app lưu uploads trong /app/uploads thì tạo sẵn thư mục + quyền
RUN mkdir -p /app/uploads && chown -R app:app /app

USER app

EXPOSE 3000

# Healthcheck (nếu app có /health)
# HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
#   CMD wget -qO- http://127.0.0.1:3000/health || exit 1

CMD ["npm", "start"]