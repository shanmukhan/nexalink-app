# Roadmap

## MVP
- Backend (`nexalink-api`, sibling repo): auth/OTP, customer/address, product (read-only), cart + checkout + order lifecycle, wallet, referral — **implemented and manually verified end-to-end** (M0–M3). `pack`/`ship`/`deliver` and wallet withdrawal approve/reject/pay have no HTTP route yet — deferred to M4 RBAC. No coupon module.
- Customer App
  - Login: **done**, real OTP flow against `nexalink-api`'s `/auth/otp/request|verify` (phone or email), tokens persisted, auto-login on relaunch, logout revokes the refresh token. An optional referral-code field on first signup captures a referral server-side.
  - Home: **done** — wallet balance and My Orders/My Team counts are real (from `/wallet`, `/orders`, `/referrals/me`); earnings breakdown (Total Earnings/This Month/Pending Payout) and Rewards stay mock, no reporting/earnings-breakdown backend yet (M5).
  - Profile, Teams: **done**. Teams shows the real referral code (shareable/copyable), referred-count vs. the policy cap, total commission earned, and the actual list of referred customers — all from `/referrals/me`.
  - Single Product (product detail, cart, checkout, order confirmation): **done**, wired end-to-end to `nexalink-api` — product fetched from `/products`, cart is the backend DRAFT order (`/cart`), checkout creates/pays a real order (`/orders/checkout`, `/orders/{id}/pay`) against a saved or newly-added delivery address (`/customers/me/addresses`). "Use wallet balance" is real in the all-or-nothing case: if the wallet balance fully covers the order, checkout pays via the real `WALLET` payment method (actually debits the ledger); otherwise it's just an on-screen estimate, since a single order can only have one payment method. Coupon code stays UI-only/cosmetic — no coupon module on the backend.
- Referral: **done** — signup capture via referral code (max 3 per referrer, configurable server-side), commission (₹500, configurable) credited to the referrer's wallet on delivery, visible in the Teams screen.
- Wallet: **done** — real ledger balance shown on Home/Cart, cashback credited on every successful purchase, referral commission credited on delivery, withdrawal requests debit the ledger (approve/reject/pay is an M4 admin feature, not built yet). No dedicated wallet-history/withdrawal screen in the app yet — balance and cashback surface on Home/Cart/Teams only.

## V2
- Categories
- Multiple products
- Payments

## V3
- Multi-distributor
- Analytics
- AI recommendations
