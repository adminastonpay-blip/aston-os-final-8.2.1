# ASTON OS 8.0.1-final

Worker de producción para **Lane & Aston · ASTON OS** (Cloudflare Workers + Workers AI).

## Deploy

```bash
unzip aston-os-final-8.0.1.zip && cd aston-os-final
npx wrangler deploy
npx wrangler secret put ASTON_API_TOKEN        # token maestro para endpoints privados
```

- **Nombre del Worker:** `name` en `wrangler.toml` decide cuál Worker se crea/reemplaza. Para reemplazar el que ya usa tu sección Shopify, pon `name = "bold-river-9b3b"`.
- **Mínimo para andar:** binding `AI` (ya está) + el Durable Object `RateLimiter` (ya declarado, sin recursos que crear).
- **Recomendado:** KV `ASTON_KV` (sesiones), D1 `ASTON_DB` + `schema.sql`, R2 `ASTON_R2` (videos). Cada bloque está comentado en `wrangler.toml` con el comando para crearlo.
- **Video async / eventos / cron:** crear la cola `aston-events` y descomentar productor + consumidor.

## Acceso

| Nivel | Endpoints | Requisito |
|---|---|---|
| Público (navegador) | `POST /v1/chat` `/v1/tts` `/v1/voice` `/v1/vision` | `Origin` en `ASTON_ALLOWED_ORIGIN` + rate limit |
| Privado | `/v1/solve` (o `mode:"deep"`), `/v1/video*`, `/v1/intent`, `/v1/validate`, `/v1/records`, `/v1/ingest`, detalle de `/health` | `Authorization: Bearer <token>` |
| Abierto | `GET /`, `/health` (mínimo), `/v1/models`, `/v1/voice/profiles` | — |

El header `Origin` lo puede falsificar un script fuera del navegador: es una barrera + rate limit, no autenticación. **Nunca pongas el token Bearer en el tema de Shopify.** Para abrir `deep` o `intent` al navegador: `ASTON_PUBLIC_ENDPOINTS = "deep,intent"`.

Multi-tenant: `ASTON_TENANT_TOKENS` (secret, JSON `{"laneaston":"tok1","acme":"tok2"}`) liga cada token a su tenant. Con el token maestro, `X-Aston-Tenant` solo acepta los tenants de `ASTON_TENANTS`.

## Contrato Shopify (sin cambios)

```json
{ "message": "Hola", "session_id": "<16-80 chars [A-Za-z0-9_-]>", "channel": "aston_os_2030",
  "language": "es-AR", "agent": { "actions_enabled": true } }
```
Respuesta: `answer`, `message`, `session_id`, `actions`, `speech`, `model`.

## Cambios 8.0.0 → 8.0.1

- TTS: Aura devuelve `ReadableStream`; ahora se lee y se entrega como audio real (antes respondía `ok` sin audio).
- Video: IDs de terceros sin `@cf/` (`alibaba/wan-3.0-prime`, `black-forest-labs/flux-3-video`); la URL firmada del proveedor (~2 h) se copia a R2; nueva ruta `GET /v1/video/:id/file`; async por Cola (antes `waitUntil`, que se corta a ~30 s). Solo texto→video; sin audio por defecto (`generate_audio:true` para activarlo); máx. 10 s (`ASTON_VIDEO_MAX_S`). Sin cascada entre modelos de video (evita cobrar dos veces).
- Rate limit atómico con Durable Object (antes KV no atómico y fail-open). Sin el DO cae a un limitador local por isolate.
- El cliente ya no elige modelo (solo con Bearer y dentro de la lista), `max_tokens` acotado, máx. 4 intentos de cascada.
- Cascada con IDs verificados en el catálogo de Workers AI (agosto 2026); se quitó `llama-3.1-8b-instruct-fast` (no existe) y `deepseek-r1` de los defaults.
- `/v1/validate` ya no inventa `valid:true`; 503 si no hay D1.
- Records: failover a D1 de respaldo solo ante error; aislamiento por tenant.
- Token comparado en tiempo constante, `session_id` validado, contexto del cliente marcado como no confiable, errores internos no se devuelven al público, body leído con límite real.
- `/health` público mínimo; `/v1/chat/completions` devuelve `choices`.

## Límites conocidos

- El historial de sesión en KV no es atómico (dos mensajes simultáneos de la misma sesión pueden pisarse).
- Con KV y sin Durable Object no hay rate limit global, solo por isolate.
- Los IDs de modelo cambian seguido: revisa https://developers.cloudflare.com/ai/models/ antes de cada release.
