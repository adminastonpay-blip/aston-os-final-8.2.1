CREATE TABLE IF NOT EXISTS events (
  id TEXT PRIMARY KEY,
  type TEXT,
  payload TEXT,
  created_at TEXT
);
CREATE INDEX IF NOT EXISTS idx_events_created ON events(created_at);

CREATE TABLE IF NOT EXISTS enterprise_records (
  id TEXT PRIMARY KEY,
  tenant_id TEXT NOT NULL,
  title TEXT,
  payload TEXT,
  created_at TEXT
);
CREATE INDEX IF NOT EXISTS idx_records_tenant_created ON enterprise_records(tenant_id, created_at DESC);

CREATE TABLE IF NOT EXISTS subscriptions (
  id TEXT PRIMARY KEY,
  account_id TEXT NOT NULL,
  plan TEXT,
  status TEXT,
  expires_at TEXT,
  created_at TEXT DEFAULT (datetime('now'))
);
CREATE INDEX IF NOT EXISTS idx_sub_account ON subscriptions(account_id, expires_at);
