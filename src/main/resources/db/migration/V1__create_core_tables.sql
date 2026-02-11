CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE gateway_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    commission_fixed NUMERIC(18,2) NOT NULL DEFAULT 0,
    commission_pct NUMERIC(10,6) NOT NULL DEFAULT 0,
    daily_limit NUMERIC(18,2),
    min_transaction NUMERIC(18,2) NOT NULL DEFAULT 0,
    max_transaction NUMERIC(18,2),
    processing_time TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE gateway_availability_windows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gateway_id UUID NOT NULL REFERENCES gateway_profiles(id) ON DELETE CASCADE,
    day_of_week SMALLINT NOT NULL CHECK (day_of_week BETWEEN 1 AND 7),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL
);

CREATE INDEX idx_gateway_availability_windows_gateway_day
    ON gateway_availability_windows (gateway_id, day_of_week);

CREATE TABLE billers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    biller_code TEXT NOT NULL UNIQUE,
    name TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE biller_quota (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    biller_id UUID NOT NULL REFERENCES billers(id) ON DELETE CASCADE,
    gateway_id UUID NOT NULL REFERENCES gateway_profiles(id) ON DELETE CASCADE,
    quota_date DATE NOT NULL,
    amount_used NUMERIC(18,2) NOT NULL DEFAULT 0,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (biller_id, gateway_id, quota_date)
);

CREATE INDEX idx_biller_quota_biller_date
    ON biller_quota (biller_id, quota_date);

CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    biller_id UUID NOT NULL REFERENCES billers(id),
    gateway_id UUID REFERENCES gateway_profiles(id),
    amount NUMERIC(18,2) NOT NULL,
    commission NUMERIC(18,2) NOT NULL,
    status TEXT NOT NULL,
    urgency TEXT NOT NULL,
    requires_split BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    processed_at TIMESTAMPTZ
);

CREATE INDEX idx_transactions_biller_created
    ON transactions (biller_id, created_at);

CREATE INDEX idx_transactions_gateway_created
    ON transactions (gateway_id, created_at);

CREATE TABLE transaction_splits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_id UUID NOT NULL REFERENCES transactions(id) ON DELETE CASCADE,
    gateway_id UUID NOT NULL REFERENCES gateway_profiles(id),
    split_index INT NOT NULL,
    amount NUMERIC(18,2) NOT NULL,
    commission NUMERIC(18,2) NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    processed_at TIMESTAMPTZ
);

CREATE INDEX idx_transaction_splits_transaction
    ON transaction_splits (transaction_id);
