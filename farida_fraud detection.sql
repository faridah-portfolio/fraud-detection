
-- STEP 1: CREATE DATABASE
-- ============================================================

CREATE DATABASE fraud_detection_db;
USE fraud_detection_db;


-- ============================================================
-- STEP 2: CREATE TABLES
-- ============================================================

-- Table 1: Users
CREATE TABLE users (
    user_id       VARCHAR(10)  PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(100) UNIQUE NOT NULL,
    country       VARCHAR(50)  NOT NULL,
    account_type  VARCHAR(20)  CHECK (account_type IN ('personal', 'business', 'premium')),
    created_at    DATETIME     DEFAULT CURRENT_TIMESTAMP
);

-- Table 2: Merchants
CREATE TABLE merchants (
    merchant_id   VARCHAR(10)  PRIMARY KEY,
    merchant_name VARCHAR(100) NOT NULL,
    category      VARCHAR(50),
    country       VARCHAR(50)
);

-- Table 3: Transactions (main fact table)
CREATE TABLE transactions (
    transaction_id   VARCHAR(12)    PRIMARY KEY,
    user_id          VARCHAR(10)    NOT NULL,
    merchant_id      VARCHAR(10)    NOT NULL,
    transaction_type VARCHAR(20)    CHECK (transaction_type IN ('purchase', 'withdrawal', 'transfer', 'online_purchase', 'refund')),
    amount           DECIMAL(10,2)  NOT NULL,
    currency         VARCHAR(5)     DEFAULT 'USD',
    country          VARCHAR(50),
    transaction_time DATETIME       NOT NULL,
    is_fraud         TINYINT(1)     DEFAULT 0,
    FOREIGN KEY (user_id)     REFERENCES users(user_id),
    FOREIGN KEY (merchant_id) REFERENCES merchants(merchant_id)
);

-- Table 4: Fraud Signals (behavioral features per transaction)
CREATE TABLE fraud_signals (
    signal_id        INT           PRIMARY KEY AUTO_INCREMENT,
    transaction_id   VARCHAR(12)   NOT NULL,
    risk_score       DECIMAL(5,4)  CHECK (risk_score BETWEEN 0 AND 1),
    login_attempts   INT           DEFAULT 1,
    device_mismatch  TINYINT(1)    DEFAULT 0,
    ip_country       VARCHAR(50),
    flagged_by_rule  TINYINT(1)    DEFAULT 0,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);

-- Table 5: Fraud Alerts (cases flagged for review)
CREATE TABLE fraud_alerts (
    alert_id         INT          PRIMARY KEY AUTO_INCREMENT,
    transaction_id   VARCHAR(12)  NOT NULL,
    alert_type       VARCHAR(50),
    alert_reason     VARCHAR(255),
    severity         VARCHAR(10)  CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    status           VARCHAR(20)  DEFAULT 'open' CHECK (status IN ('open', 'investigating', 'resolved', 'false_positive')),
    created_at       DATETIME     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);


-- ============================================================
-- STEP 3: INSERT SAMPLE DATA
-- ============================================================

-- Insert Users
INSERT INTO users (user_id, full_name, email, country, account_type) VALUES
('USR0001', 'Amara Okafor',    'amara.o@email.com',   'Nigeria', 'personal'),
('USR0002', 'James Carter',    'j.carter@email.com',  'US',      'premium'),
('USR0003', 'Li Wei',          'li.wei@email.com',    'China',   'business'),
('USR0004', 'Fatima Al-Sayed', 'fatima.a@email.com',  'UK',      'personal'),
('USR0005', 'Ivan Petrov',     'ivan.p@email.com',    'Russia',  'personal'),
('USR0006', 'Sofia Martins',   'sofia.m@email.com',   'US',      'premium'),
('USR0007', 'Chen Jing',       'chen.j@email.com',    'China',   'business'),
('USR0008', 'David Nwosu',     'david.n@email.com',   'Nigeria', 'personal'),
('USR0009', 'Emma Thompson',   'emma.t@email.com',    'UK',      'premium'),
('USR0010', 'Alexei Volkov',   'alexei.v@email.com',  'Russia',  'personal');

-- Insert Merchants
INSERT INTO merchants (merchant_id, merchant_name, category, country) VALUES
('MER001', 'Amazon',           'E-Commerce',    'US'),
('MER002', 'Walmart',          'Retail',        'US'),
('MER003', 'Netflix',          'Streaming',     'US'),
('MER004', 'Shell',            'Fuel',          'UK'),
('MER005', 'PayPal',           'Fintech',       'US'),
('MER006', 'Unknown_Vendor_A', 'Unknown',       'Unknown'),
('MER007', 'Unknown_Vendor_B', 'Unknown',       'Unknown'),
('MER008', 'Best Buy',         'Electronics',   'US'),
('MER009', 'Target',           'Retail',        'US'),
('MER010', 'McDonalds',        'Food',          'US');

-- Insert Transactions
INSERT INTO transactions (transaction_id, user_id, merchant_id, transaction_type, amount, country, transaction_time, is_fraud) VALUES
('TXN000001', 'USR0001', 'MER001', 'online_purchase', 45.99,   'Nigeria', '2024-01-03 14:22:00', 0),
('TXN000002', 'USR0002', 'MER002', 'purchase',         120.50,  'US',      '2024-01-05 09:10:00', 0),
('TXN000003', 'USR0003', 'MER006', 'transfer',         3500.00, 'China',   '2024-01-07 00:45:00', 1),
('TXN000004', 'USR0004', 'MER004', 'purchase',         60.00,   'UK',      '2024-01-08 11:30:00', 0),
('TXN000005', 'USR0005', 'MER007', 'online_purchase',  2800.00, 'Russia',  '2024-01-09 01:15:00', 1),
('TXN000006', 'USR0006', 'MER003', 'purchase',         15.99,   'US',      '2024-01-10 19:00:00', 0),
('TXN000007', 'USR0007', 'MER001', 'withdrawal',       4900.00, 'China',   '2024-01-11 23:50:00', 1),
('TXN000008', 'USR0008', 'MER009', 'purchase',         75.00,   'Nigeria', '2024-01-12 16:20:00', 0),
('TXN000009', 'USR0009', 'MER005', 'transfer',         200.00,  'UK',      '2024-01-13 10:05:00', 0),
('TXN000010', 'USR0010', 'MER006', 'refund',           1200.00, 'Russia',  '2024-01-14 02:30:00', 1);

-- Insert Fraud Signals
INSERT INTO fraud_signals (transaction_id, risk_score, login_attempts, device_mismatch, ip_country, flagged_by_rule) VALUES
('TXN000001', 0.12, 1, 0, 'Nigeria', 0),
('TXN000002', 0.08, 1, 0, 'US',      0),
('TXN000003', 0.91, 6, 1, 'Unknown', 1),
('TXN000004', 0.15, 1, 0, 'UK',      0),
('TXN000005', 0.88, 5, 1, 'Unknown', 1),
('TXN000006', 0.05, 1, 0, 'US',      0),
('TXN000007', 0.97, 7, 1, 'Unknown', 1),
('TXN000008', 0.20, 2, 0, 'Nigeria', 0),
('TXN000009', 0.11, 1, 0, 'UK',      0),
('TXN000010', 0.85, 4, 1, 'Unknown', 1);

-- Insert Fraud Alerts (for confirmed fraud transactions only)
INSERT INTO fraud_alerts (transaction_id, alert_type, alert_reason, severity, status) VALUES
('TXN000003', 'high_amount',    'Transfer amount exceeds $3,000 with device mismatch',  'critical', 'investigating'),
('TXN000005', 'device_mismatch','Login from unrecognized device with 5 failed attempts', 'high',     'open'),
('TXN000007', 'night_activity', 'Large withdrawal at 23:50 from mismatched device',      'critical', 'open'),
('TXN000010', 'ip_anomaly',     'IP country does not match registered country',           'high',     'open');


-- ============================================================
-- STEP 4: ANALYSIS QUERIES
-- ============================================================

-- ------------------------------------------------------------
-- A. OVERVIEW — Dataset summary
-- ------------------------------------------------------------
SELECT
    COUNT(*)                                        AS total_transactions,
    SUM(is_fraud)                                   AS fraud_count,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2)      AS fraud_rate_pct,
    ROUND(AVG(amount), 2)                           AS avg_transaction_amount,
    ROUND(SUM(amount), 2)                           AS total_volume
FROM transactions;


-- ------------------------------------------------------------
-- B. FRAUD vs LEGITIMATE — Side-by-side comparison
-- ------------------------------------------------------------
SELECT
    CASE WHEN is_fraud = 1 THEN 'Fraud' ELSE 'Legitimate' END  AS category,
    COUNT(*)                                                    AS total_count,
    ROUND(AVG(t.amount), 2)                                     AS avg_amount,
    ROUND(MAX(t.amount), 2)                                     AS max_amount,
    ROUND(AVG(fs.risk_score), 4)                                AS avg_risk_score,
    ROUND(AVG(fs.login_attempts), 2)                            AS avg_login_attempts,
    ROUND(AVG(fs.device_mismatch) * 100, 1)                     AS device_mismatch_pct
FROM transactions t
JOIN fraud_signals fs ON t.transaction_id = fs.transaction_id
GROUP BY is_fraud;


-- ------------------------------------------------------------
-- C. ANOMALY DETECTION — Fraud by amount range
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN amount < 50              THEN '< $50'
        WHEN amount BETWEEN 50 AND 200  THEN '$50 – $200'
        WHEN amount BETWEEN 200 AND 500 THEN '$200 – $500'
        WHEN amount BETWEEN 500 AND 1000 THEN '$500 – $1,000'
        ELSE '> $1,000'
    END                                              AS amount_range,
    COUNT(*)                                         AS total,
    SUM(is_fraud)                                    AS fraud_count,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2)       AS fraud_rate_pct
FROM transactions
GROUP BY amount_range
ORDER BY MIN(amount);


-- ------------------------------------------------------------
-- D. PATTERN RECOGNITION — Fraud by transaction type
-- ------------------------------------------------------------
SELECT
    transaction_type,
    COUNT(*)                                          AS total,
    SUM(is_fraud)                                     AS fraud_count,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2)        AS fraud_rate_pct,
    ROUND(AVG(CASE WHEN is_fraud = 1 THEN amount END), 2) AS avg_fraud_amount
FROM transactions
GROUP BY transaction_type
ORDER BY fraud_rate_pct DESC;


-- ------------------------------------------------------------
-- E. GEOGRAPHIC RISK — Fraud rate by country
-- ------------------------------------------------------------
SELECT
    t.country,
    COUNT(*)                                          AS total_transactions,
    SUM(is_fraud)                                     AS fraud_count,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2)        AS fraud_rate_pct,
    ROUND(AVG(CASE WHEN is_fraud = 1 THEN amount END), 2) AS avg_fraud_amount
FROM transactions t
GROUP BY t.country
ORDER BY fraud_rate_pct DESC;


-- ------------------------------------------------------------
-- F. MERCHANT RISK — Fraud rate by merchant
-- ------------------------------------------------------------
SELECT
    m.merchant_name,
    m.category,
    COUNT(*)                                          AS total_transactions,
    SUM(t.is_fraud)                                   AS fraud_count,
    ROUND(SUM(t.is_fraud) * 100.0 / COUNT(*), 2)      AS fraud_rate_pct
FROM transactions t
JOIN merchants m ON t.merchant_id = m.merchant_id
GROUP BY m.merchant_name, m.category
ORDER BY fraud_rate_pct DESC;


-- ------------------------------------------------------------
-- G. REAL-TIME MONITORING — Fraud by hour of day
-- ------------------------------------------------------------
SELECT
    HOUR(transaction_time)                            AS hour_of_day,
    COUNT(*)                                          AS total_transactions,
    SUM(is_fraud)                                     AS fraud_count,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2)        AS fraud_rate_pct
FROM transactions
GROUP BY HOUR(transaction_time)
ORDER BY hour_of_day;


-- ------------------------------------------------------------
-- H. RISK SCORE ANALYSIS — Distribution by bracket
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN fs.risk_score < 0.25  THEN 'Low      (0.00 – 0.25)'
        WHEN fs.risk_score < 0.50  THEN 'Medium   (0.25 – 0.50)'
        WHEN fs.risk_score < 0.75  THEN 'High     (0.50 – 0.75)'
        ELSE                            'Critical (0.75 – 1.00)'
    END                                               AS risk_bracket,
    COUNT(*)                                          AS total,
    SUM(t.is_fraud)                                   AS fraud_count,
    ROUND(SUM(t.is_fraud) * 100.0 / COUNT(*), 2)      AS fraud_rate_pct
FROM fraud_signals fs
JOIN transactions t ON fs.transaction_id = t.transaction_id
GROUP BY risk_bracket
ORDER BY MIN(fs.risk_score);


-- ------------------------------------------------------------
-- I. COMPOUND ANOMALY — Device mismatch + login attempts
-- ------------------------------------------------------------
SELECT
    fs.device_mismatch,
    CASE
        WHEN fs.login_attempts = 1           THEN '1 attempt'
        WHEN fs.login_attempts = 2           THEN '2 attempts'
        WHEN fs.login_attempts BETWEEN 3 AND 5 THEN '3 – 5 attempts'
        ELSE                                      '6+ attempts'
    END                                           AS login_group,
    COUNT(*)                                      AS total,
    SUM(t.is_fraud)                               AS fraud_count,
    ROUND(SUM(t.is_fraud) * 100.0 / COUNT(*), 2)  AS fraud_rate_pct
FROM fraud_signals fs
JOIN transactions t ON fs.transaction_id = t.transaction_id
GROUP BY fs.device_mismatch, login_group
ORDER BY fs.device_mismatch DESC, fraud_rate_pct DESC;


-- ------------------------------------------------------------
-- J. HIGH-RISK USERS — Top users by fraud count
-- ------------------------------------------------------------
SELECT
    u.user_id,
    u.full_name,
    u.country,
    COUNT(*)                                          AS total_transactions,
    SUM(t.is_fraud)                                   AS fraud_count,
    ROUND(SUM(t.amount), 2)                           AS total_amount,
    ROUND(AVG(fs.risk_score), 4)                      AS avg_risk_score,
    ROUND(SUM(t.is_fraud) * 100.0 / COUNT(*), 2)      AS fraud_rate_pct
FROM transactions t
JOIN users u        ON t.user_id = u.user_id
JOIN fraud_signals fs ON t.transaction_id = fs.transaction_id
GROUP BY u.user_id, u.full_name, u.country
HAVING fraud_count > 0
ORDER BY fraud_count DESC, avg_risk_score DESC;


-- ------------------------------------------------------------
-- K. FRAUD ALERTS SUMMARY — Open cases by severity
-- ------------------------------------------------------------
SELECT
    severity,
    status,
    COUNT(*)                                         AS alert_count,
    GROUP_CONCAT(transaction_id ORDER BY created_at) AS transaction_ids
FROM fraud_alerts
GROUP BY severity, status
ORDER BY
    FIELD(severity, 'critical', 'high', 'medium', 'low'),
    status;


-- ------------------------------------------------------------
-- L. FULL FRAUD REPORT — Join all 5 tables
-- ------------------------------------------------------------
SELECT
    t.transaction_id,
    u.full_name,
    u.country                    AS user_country,
    m.merchant_name,
    m.category                   AS merchant_category,
    t.transaction_type,
    t.amount,
    t.transaction_time,
    fs.risk_score,
    fs.login_attempts,
    fs.device_mismatch,
    fs.ip_country,
    t.is_fraud,
    fa.severity                  AS alert_severity,
    fa.alert_reason
FROM transactions t
JOIN users         u  ON t.user_id         = u.user_id
JOIN merchants     m  ON t.merchant_id     = m.merchant_id
JOIN fraud_signals fs ON t.transaction_id  = fs.transaction_id
LEFT JOIN fraud_alerts fa ON t.transaction_id = fa.transaction_id
ORDER BY t.is_fraud DESC, fs.risk_score DESC;