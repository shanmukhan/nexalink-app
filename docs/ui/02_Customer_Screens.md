# Customer Screens

## Login
Fields:
- Phone or Email
- OTP login (preferred)
- Biometric login
- Remember device

**Current implementation:** real two-step OTP login against `nexalink-api` — enter phone/email, request OTP, enter the 6-digit code, verify (see [Functional Requirements](../04_Functional_Requirements.md#authentication)). An optional referral-code field on the first step is passed to OTP verify and captured server-side on brand-new signups only (a stray code on an existing user's login is ignored). Session persists across app relaunches; logout revokes the refresh token server-side. Biometric button and language switcher are present; biometric login is still a UI stub only. "Remember device" is not implemented.

## Home
Sections:
- Wallet summary
- Active order
- Featured products
- Categories
- Referral summary
- Notifications

**Current implementation:** wallet balance and the My Orders / My Team stat tiles are real (`GET /wallet`, `GET /orders`, `GET /referrals/me`). Total Earnings / This Month / Pending Payout and Rewards stay mock — no reporting/earnings-breakdown backend yet (M5). "Active order" and "Notifications" sections aren't built.

## Product Details
- Gallery
- Specifications
- Warranty
- Cashback eligibility
- Referral policy
- Similar products

**Current implementation:** done, replacing the old "Shop coming soon" tab, fetched live from `nexalink-api`'s `GET /products` / `GET /products/{id}`. Single MVP product only (per MVP scope, seeded server-side); gallery is a placeholder graphic; "Similar products" shows a coming-soon note.

## Cart
- Quantity
- Coupon
- Wallet usage
- Estimated cashback

**Current implementation:** done, backed by `nexalink-api`'s `/api/v1/cart` (a DRAFT order — there's no separate cart table server-side). Add/quantity changes/removal all round-trip to the backend. Coupon code `NEXA100` (₹100 off) is local/cosmetic only — no coupon module on the backend. "Use wallet balance" shows the real ledger balance (`GET /wallet`) and is genuinely honored at checkout in the all-or-nothing case (see Checkout below); if the balance only partially covers the order, the deduction shown is an estimate only.

## Checkout
- Address
- Payment
- Wallet
- GST invoice option

**Current implementation:** done. Delivery address is fetched from `GET /customers/me/addresses`; if none exists yet, an inline form creates one via `POST /customers/me/addresses`. If the wallet balance fully covers the order subtotal and "use wallet balance" is on, checkout pays with the real `WALLET` payment method — `POST /orders/{id}/pay` actually debits the ledger, and an insufficient balance is rejected (422, order stays `PENDING` and retryable). Otherwise the selected payment method (UPI/Card/COD) is sent to `POST /orders/checkout` — the backend's payment step for those is a stub that always succeeds (no real gateway yet, see `nexalink-api` roadmap). Every successful payment, regardless of method, credits cashback to the wallet. GST invoice toggle reveals a GSTIN field with no validation/backend.

## Orders
Status timeline:
Placed > Paid > Packed > Shipped > Delivered

**Current implementation:** order confirmation screen shows the real order returned by checkout/pay — order id, invoice number, and status-derived timeline. `pack`/`ship`/`deliver` have no backend route yet (deferred to `nexalink-api`'s M4/RBAC), so the timeline won't progress past "Paid" until that ships.

## Referral Tree
- Expand/collapse tree
- Referral count
- Eligible referrals remaining

**Current implementation:** the Teams tab shows the real referral code (copyable), referred-count vs. the server's policy cap (`GET /referrals/me`), total commission earned, and the actual list of referred customers with their signup date. Single-level only — no expand/collapse multi-level tree (the backend's `referral` table is self-referencing and could support one, but nothing walks more than one level yet).

## Wallet
- Ledger
- Credits
- Debits
- Withdrawals
- Cashback history

**Current implementation:** balance and cashback credits are real, surfaced on Home/Cart/Teams (see those sections). No dedicated wallet-history or withdrawal-request screen exists in the app yet, even though the backend supports both (`GET /wallet/transactions`, `POST /wallet/withdrawals`) — next candidate to wire.

## Notifications
Grouped by:
Orders
Wallet
Referral
Offers

## Profile
Mandatory:
- Name
- Gender
- Aadhaar (encrypted/KYC)

Optional:
- Religious places wishlist
- Product wishlist
- Referral contacts
- Employment references
- Foreign tour wishlist
