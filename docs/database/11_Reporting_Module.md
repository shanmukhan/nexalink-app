# Reporting Module

Materialized views recommended for:

- Sales summary
- Wallet summary
- Referral analytics
- Inventory analytics

## What actually shipped (Phase 5)

The Home screen's earnings mini-stats (`GET /api/v1/reporting/earnings-summary`,
`com.nexalink.backend.reporting` package in nexalink-api) were built as **direct
on-the-fly aggregation** over the existing `wallet_transaction` and
`withdrawal_request` tables instead of the materialized views sketched above:

- `totalEarnings` — lifetime `sum(amount)` of this customer's `wallet_transaction`
  rows where `type = CREDIT` (`WalletService.getTotalEarnings`).
- `thisMonth` — same sum, bounded to `created_at >= <start of current calendar
  month, UTC>` (`WalletService.getEarningsSince`).
- `pendingPayout` — `sum(amount)` of this customer's `withdrawal_request` rows with
  `status IN (PENDING, APPROVED)` (`WalletService.getPendingPayout`).

All three are per-customer indexed sums (`customer_id` is indexed on both tables),
so a view isn't warranted yet — this is simpler to reason about and always
consistent (no refresh lag). Revisit with a materialized view only if this
endpoint's query cost becomes a real problem at scale, or once admin-facing
sales/inventory summaries (still not started) need cross-customer aggregation that
this per-customer approach doesn't cover.
