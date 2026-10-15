# ASTON OS 8.0.1-final — Cloudflare Workers
#
# IMPORTANT: "name" decides WHICH Worker gets deployed/overwritten.
#   - Keep "aston-os-final" to create a NEW Worker (https://aston-os-final.<tu-subdominio>.workers.dev).
#   - Use  name = "bold-river-9b3b"  to REPLACE the Worker your Shopify section already calls.
name = "aston-os-final"
main = "src/index.js"
compatibility_date = "2026-10-01"
workers_dev = true

[observability]
enabled = true

# Workers AI (required)
[ai]
binding = "AI"

# Atomic rate limiter (Durable Object, SQLite-backed: works on the Free plan). No resources to create.
[[durable_objects.bindings]]
name = "RATE_LIMITER_DO"
class_name = "RateLimiter"

[[migrations]]
tag = "v1"
new_sqlite_classes = ["RateLimiter"]

[vars]
ASTON_BRAND_NAME = "Lane & Aston"
ASTON_TENANT_ID = "laneaston"
# Browser origins allowed to call the public endpoints (chat / tts / voice / vision). Comma separated.
ASTON_ALLOWED_ORIGIN = "https://www.laneaston.com,https://laneaston.com,https://m1m0d3-ru.myshopify.com"
# ASTON_ALLOW_SHOPIFY_WILDCARD = "1"     # also allow *.myshopify.com and *.shopifypreview.com (theme preview)
# ASTON_PUBLIC_ENDPOINTS = "deep,intent" # open these to browsers too (origin + rate limit instead of Bearer)
# ASTON_TENANTS = "laneaston,acme"       # tenants the master token may select with X-Aston-Tenant
# ASTON_AI_MODEL = "@cf/meta/llama-3.1-8b-instruct-fp8"
# ASTON_VOICE_PROFILE = "aston_executive"
# ASTON_RATE_LIMIT = "30"                # base requests/minute per client (x5 for Bearer callers)
# ASTON_VIDEO_MAX_S = "10"               # max seconds per generated video

# ── Optional bindings. Create the resource first, then uncomment. ──────────────────────────
# KV (sessions, video job status):        npx wrangler kv namespace create ASTON_KV
# [[kv_namespaces]]
# binding = "ASTON_KV"
# id = "YOUR_KV_ID"

# D1 (records, subscriptions, events):    npx wrangler d1 create aston-os
#                                         npx wrangler d1 execute aston-os --remote --file=schema.sql
# [[d1_databases]]
# binding = "ASTON_DB"
# database_name = "aston-os"
# database_id = "YOUR_D1_ID"

# Optional failover database (same schema). Used only if the primary errors.
# [[d1_databases]]
# binding = "ASTON_DB_BACKUP"
# database_name = "aston-os-backup"
# database_id = "YOUR_D1_BACKUP_ID"

# R2 (video files, records/ingest archive): npx wrangler r2 bucket create aston-os-lake
# [[r2_buckets]]
# binding = "ASTON_R2"
# bucket_name = "aston-os-lake"

# Queue (async video, event log, cron events): npx wrangler queues create aston-events
# [[queues.producers]]
# binding = "EVENTS"
# queue = "aston-events"
#
# [[queues.consumers]]
# queue = "aston-events"
# max_batch_size = 5
# max_batch_timeout = 5
# max_retries = 3

# Cron (needs the EVENTS queue to do anything):
# [triggers]
# crons = ["0 * * * *"]

# ── Secrets (never put these in this file) ─────────────────────────────────────────────────
#   npx wrangler secret put ASTON_API_TOKEN         # master Bearer token
#   npx wrangler secret put ASTON_TENANT_TOKENS     # optional JSON: {"laneaston":"tok1","acme":"tok2"}
