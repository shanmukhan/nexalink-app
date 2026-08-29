# Functional Requirements

## Language Settings

Customer can:
- Select English
- Select Telugu
- Change language anytime
- Language updates immediately
- Preference synced across devices

## Authentication
- Phone OTP
- Email OTP
- **Current implementation:** real OTP flow against `nexalink-api`'s `/api/v1/auth/otp/request|verify` — phone or email, 6-digit code, session (access + refresh token) persisted on-device and auto-restored on relaunch. OTP delivery is stubbed server-side (logged, not actually sent via SMS/email) until a real provider is integrated.

## Product
- Categories
- Search
- Wishlist

## Orders
- Cart
- Checkout
- Tracking

## Wallet
- Ledger transactions
- Cashback
- Withdrawal
- **Current implementation:** real ledger against `nexalink-api`'s `/api/v1/wallet/*` — balance is derived server-side (never a mutable column), cashback credits on every successful order payment, withdrawal requests debit the ledger immediately. No admin approve/reject/pay flow yet (M4/RBAC) and no dedicated wallet-history/withdrawal screen in the app — balance and cashback surface on Home/Cart/Teams.

## Referral
- Referral tree
- Referral history
- Commission
- **Current implementation:** real referral capture + commission against `nexalink-api`'s `/api/v1/referrals/*` — an optional referral code at signup links referrer/referee (server-enforced cap, configurable, seeded at 3), commission (seeded at ₹500) credits to the referrer's wallet when the referred order is delivered. Single-level only (no multi-level tree walk yet, though the schema supports it).

## Reports
- Sales
- Earnings
- Inventory
