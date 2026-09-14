# Wallet Module

Tables

- wallet
- wallet_transaction
- withdrawal_request

Wallet is ledger based.

Balance = Sum(Credits) - Sum(Debits)

`withdrawal_request` lifecycle: `PENDING` (funds debited/reserved immediately on
request) → `APPROVED` (admin action, pure status transition, no further ledger
movement) → `PAID` (admin action, records `payout_reference` — added by
`V11__add_withdrawal_payout_reference.sql` — and sets `processed_at`), or `PENDING` →
`REJECTED` (admin action, reverses the reserving debit with a CREDIT/
`WITHDRAWAL_REVERSAL` entry). Admin routes (`/api/v1/admin/withdrawals/...`,
`ADMIN`-role gated) landed in Phase 3 of `../11_Pending_Work_Plan.md` — see
`nexalink-api/docs/08_Implementation_Roadmap.md`'s M3 section for the full route list.
