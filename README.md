# 🔍 Fraud Detection System — SQL Analysis

![SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?style=flat&logo=mysql&logoColor=white)
![HTML](https://img.shields.io/badge/Visualization-HTML%20%2B%20Chart.js-E34F26?style=flat&logo=html5&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=flat)
![Domain](https://img.shields.io/badge/Domain-Financial%20Analytics-blueviolet?style=flat)
![Records](https://img.shields.io/badge/Records-10%2C000%20Transactions-orange?style=flat)

---

## 📌 Project Overview 

This project demonstrates an end-to-end **fraud detection system** built entirely in SQL. Starting from database design through to analytical reporting, it identifies fraudulent financial transactions using anomaly detection, risk scoring, behavioral signals, and real-time monitoring patterns.

The analysis uncovers high-risk users, suspicious merchants, geographic fraud clusters, and compound behavioral anomalies — the kind of insights a financial institution would act on immediately.

---

## 🎯 Business Problem

Financial fraud costs institutions billions annually and traditional rule-based systems miss increasingly sophisticated attacks. This project answers:

- Which transactions are statistically anomalous by amount, time, or behavior?
- What combination of signals (risk score + device mismatch + login attempts) best predicts fraud?
- Which merchants, countries, and transaction types carry the highest fraud risk?
- How can SQL alone power a scalable fraud detection pipeline?

---

## 🗄️ Database Schema

Five relational tables model the full fraud detection ecosystem:

```
users ──────────┐
                ├──▶ transactions ──▶ fraud_signals
merchants ──────┘         │
                          └──────▶ fraud_alerts
```

| Table | Description | Key Columns |
|---|---|---|
| `users` | Registered account holders | `user_id`, `country`, `account_type` |
| `merchants` | Transaction destinations | `merchant_id`, `category`, `country` |
| `transactions` | Core fact table | `amount`, `transaction_type`, `is_fraud` |
| `fraud_signals` | Behavioral features | `risk_score`, `login_attempts`, `device_mismatch` |
| `fraud_alerts` | Flagged cases | `severity`, `alert_reason`, `status` |

---

## 🔎 SQL Analysis Performed

| Query | Technique | Purpose |
|---|---|---|
| Dataset Overview | Aggregation | Total volume, fraud rate, avg amounts |
| Fraud vs Legitimate | GROUP BY + CASE | Side-by-side KPI comparison |
| Amount Anomaly Detection | CASE bucketing | Fraud rate by transaction size range |
| Transaction Type Risk | GROUP BY + ratio | Which tx types attract more fraud |
| Geographic Risk | GROUP BY + ratio | Country-level fraud concentration |
| Merchant Risk Ranking | JOIN + ratio | Highest-risk merchants by category |
| Hourly Pattern Monitoring | HOUR() + ratio | Real-time time-of-day fraud peaks |
| Risk Score Distribution | CASE bucketing | Fraud rate across risk score brackets |
| Compound Anomaly Rule | Multi-column GROUP BY | Device mismatch × login attempts |
| High-Risk User Report | JOIN + HAVING | Users with confirmed fraud history |
| Alert Severity Summary | GROUP BY + FIELD() | Open fraud cases by urgency |
| Full Fraud Report | 5-table JOIN | Complete transaction audit view |

---

## 💡 Key Findings

**Amount is the strongest signal**
All transactions above $500 are fraudulent in this dataset — a simple threshold rule catches 100% of high-value fraud.

**Compound behavioral rules work best**
Device mismatch combined with 3+ failed login attempts produces a 100% fraud detection rate — far more reliable than either signal alone.

**Risk score is a clean classifier**
Every transaction with `risk_score ≥ 0.5` is fraud; every transaction below 0.5 is legitimate. A single WHERE clause separates all cases.

**Midnight is the riskiest hour**
Fraud activity peaks at 00:00–01:00 (4.1% fraud rate) — enhanced monitoring during late-night hours would reduce exposure.

**Unknown vendors dominate fraud**
Merchants categorised as "Unknown" account for the majority of fraud cases — flagging unverified merchants at onboarding prevents downstream losses.

---

## 📊 Fraud Statistics Summary

| Metric | Value |
|---|---|
| Total transactions | 10,000 |
| Fraud cases | 288 |
| Fraud rate | 2.88% |
| Avg legitimate amount | $84.74 |
| Avg fraud amount | $2,756.00 |
| Avg fraud risk score | 0.82 |
| Device mismatch rate (fraud) | 80.2% |
| Avg login attempts (fraud) | 5.02 |

---

## 🛠️ Tools & Technologies

- **Database:** MySQL
- **Language:** SQL (DDL + DML + Analytical queries)
- **Visualization:** HTML + CSS + Chart.js
- **Techniques:** JOINs, CTEs, CASE expressions, aggregate functions, window patterns, multi-table reporting

---

## 📊 Dashboard Preview

The project includes a standalone HTML dashboard that visualizes all SQL query results:

- Fraud rate by amount range (bar chart)
- Fraud rate by country and transaction type
- Hourly fraud pattern across 24 hours (line chart)
- Risk score distribution — fraud vs legitimate (stacked bar)
- Device mismatch × login attempts compound signal (grouped bar)
- KPI metric cards for instant overview

> Open `fraud-detection-2dd594.netlify.app` directly in any browser — no server needed.
![github_link](https://github.com/faridah-portfolio/fraud-detection/blob/242d8628317909f420eaba5d9780301b100e75c5/farida_fraud%20detection.sql)

![github link](fraud-detection-2dd594.netlify.app)

## 👩🏾‍💻 Author

**Faridah Abubakar**  
Data Analyst | Power BI Developer | SQL & Python

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=flat&logo=linkedin)](https://linkedin.com/in/faridah-abubakar)
[![Email](https://img.shields.io/badge/Email-Contact-D14836?style=flat&logo=gmail&logoColor=white)](mailto:farisoiza64@gmail.com)

---


