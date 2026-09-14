# Pending Work Plan

Working plan for the items identified as pending on 2026-09-13 (see `09_Project_Roadmap.md`).
Scope decision: admin-only actions (pack/ship/deliver, withdrawal approve/reject/pay) get
**backend endpoints only** for now, secured by role — no admin UI yet. A dedicated
`flutter_admin` app remains a separate future project per `07_Project_Structure.md`.

Phases are ordered by dependency. Each phase's backend work happens in the sibling
`nexalink-api` repo; docs there (`08_Implementation_Roadmap.md`, `database/09_Admin_Module.md`,
etc.) get updated as each phase lands, same as this file.

## Phase 1 — RBAC / admin module (`nexalink-api`, M4)
- Migration: `role`, `permission`, `role_permission`, `user_role` tables per
  `database/09_Admin_Module.md`.
- Seed `ADMIN` and `DISTRIBUTOR` roles with permissions covering order fulfillment
  (`ORDER_PACK`, `ORDER_SHIP`, `ORDER_DELIVER`) and wallet payouts
  (`WALLET_WITHDRAWAL_APPROVE`, `WALLET_WITHDRAWAL_REJECT`, `WALLET_WITHDRAWAL_PAY`).
  `CUSTOMER` stays the default role assigned at signup.
- `AuthService`/`JwtService`: resolve a customer's actual roles from `user_role` at
  token issuance instead of the hardcoded `DEFAULT_ROLES = ["CUSTOMER"]`.
- `SecurityConfig`: enable method security (`@PreAuthorize`) for role-gated routes.
- No self-service role assignment UI — granting a role is a manual DB operation
  (documented) until an admin app exists.
- Status: **done**. `V10__create_admin_tables.sql` added `role`/`permission`/
  `role_permission`/`user_role`, seeded per the above, and backfilled every existing
  customer to `CUSTOMER`; `admin.application.RoleService` replaces `AuthService`'s
  hardcoded `DEFAULT_ROLES` at every token issuance and refresh; `SecurityConfig` now
  has `@EnableMethodSecurity` so `@PreAuthorize("hasRole(...))")` is available. See
  `database/09_Admin_Module.md` and `nexalink-api/docs/08_Implementation_Roadmap.md`
  (M4 section) for detail.

## Phase 2 — Order fulfillment routes (`nexalink-api`, M4, depends on Phase 1)
- Expose `OrderService.pack/ship/deliver` via `POST /api/v1/orders/{id}/pack|ship|deliver`,
  gated to `DISTRIBUTOR`/`ADMIN` roles. `ship` takes `{carrier, trackingNumber}`.
- Status: **done** — all three routes added to `OrderController` with
  `@PreAuthorize("hasAnyRole('DISTRIBUTOR','ADMIN')")`; `OrderService.pack/ship/deliver`
  now return the updated order. Covered by
  `OrderFulfillmentIntegrationTest` (distributor/admin pack→ship→deliver, customer
  gets 403, ship-before-pack gets 422, deliver credits referral commission).

## Phase 3 — Wallet withdrawal admin actions (`nexalink-api`, M4, depends on Phase 1)
- Add `WalletService.approveWithdrawal`/`payWithdrawal` (reject already exists).
- Admin routes: `POST /api/v1/admin/withdrawals/{id}/approve|reject|pay`,
  `GET /api/v1/admin/withdrawals?status=PENDING` (paginated queue), gated to `ADMIN`.
- Status: **done**. `WalletService.approveWithdrawal` (`PENDING → APPROVED`) and
  `payWithdrawal` (`APPROVED → PAID`, records a `payoutReference` — new
  `withdrawal_request.payout_reference` column, `V11__add_withdrawal_payout_reference.sql`)
  added; `rejectWithdrawal` unchanged. Routes live in a new
  `wallet.api.AdminWithdrawalController` (`/api/v1/admin/withdrawals`) rather than an
  `admin.api` package — the `admin` module from Phase 1 is still domain/infrastructure
  only, and this is really the next chapter of the withdrawal lifecycle `WalletController`
  already owns, so it stays in the wallet bounded context. All four routes gated
  `@PreAuthorize("hasRole('ADMIN')")`, same role-based pattern as Phase 2 (not the seeded
  `WALLET_WITHDRAWAL_*` permissions — no `PermissionEvaluator` exists yet). Covered by
  `AdminWithdrawalIntegrationTest` (full PENDING→APPROVED→PAID lifecycle, customer gets
  403 on all four routes, wrong-state approve/pay rejected 422, status-filtered queue).

## Phase 4 — Wallet history / withdrawal screen (`nexa_link`, independent of 1-3)
- New `lib/wallet_page.dart`: transaction history via existing `WalletService.listTransactions()`,
  a withdrawal request form via existing `WalletService.requestWithdrawal()`.
- Entry point from Home's wallet card and/or Profile.
- Status: **done**. Built `lib/wallet_page.dart` (balance card, paginated transaction
  history with load-more, withdrawal bottom sheet with amount validation); wired
  navigation from `lib/home_page.dart`'s wallet card/info tile and a new
  `lib/profile_page.dart` "My Wallet" option tile; `WalletService.listTransactions`
  now takes `{page, size}`; added wallet/withdrawal strings to
  `lib/l10n/app_en.arb` and `lib/l10n/app_te.arb`.

## Phase 5 — Reporting / earnings breakdown (`nexalink-api` + `nexa_link`, M5)
- Backend: `reporting` module — endpoint aggregating Total Earnings (lifetime credits),
  This Month (date-filtered credits), Pending Payout (sum of `PENDING`/`APPROVED`
  withdrawals), per `database/11_Reporting_Module.md`.
- Frontend: replace the mocked `_buildMiniStat` values in `lib/home_page.dart`
  (Total Earnings/This Month/Pending Payout, and the Rewards count) with real data.
- Status: **partially done** — Total Earnings/This Month/Pending Payout are real;
  Rewards deliberately left mocked (see below).
  - Backend: new `reporting` module —
    `GET /api/v1/reporting/earnings-summary` (`reporting.api.ReportingController` /
    `reporting.application.ReportingService`), authenticated, scoped to the calling
    customer via `CurrentUser.id()`. Calls into `WalletService` (three new methods:
    `getTotalEarnings`, `getEarningsSince`, `getPendingPayout`) rather than touching
    `wallet.infrastructure` repositories directly, per the cross-module rule. Built as
    direct aggregation over `wallet_transaction`/`withdrawal_request`, not the
    materialized views `database/11_Reporting_Module.md` originally sketched — see
    that doc's "What actually shipped" section for why. No new Flyway migration
    needed (read-only). Covered by
    `src/test/java/.../reporting/ReportingIntegrationTest.java` (cross-month
    aggregation, PENDING/APPROVED/REJECTED withdrawal handling, no cross-customer
    leakage).
  - Frontend: `WalletService.getEarningsSummary()` (added to the existing wallet
    service rather than a new `ReportingService`, since the data is wallet-derived
    and it's the only consumer so far) + `EarningsSummary` model in
    `lib/api_models.dart`; `lib/home_page.dart`'s `_HomeDashboardState` now fetches
    it alongside the order/team counts and renders real ₹ values (with the same
    `'—'` loading placeholder convention as order/team counts) in place of the
    `'₹ 45,680'` / `'₹ 8,750'` / `'₹ 2,350'` mocks. No new l10n keys needed — the
    `totalEarnings`/`thisMonth`/`pendingPayout` labels already existed.
  - Deviation: the Home screen's "Rewards" count (`'33'` in `_buildInfoCard`) is
    **left mocked on purpose**. Neither the Flutter roadmap doc nor the backend has
    any "rewards" concept (no rewards/points/badges table or module) — the only
    real candidate, referral count, is already surfaced separately as "My Team".
    Inventing a business rule for what "Rewards" should count wasn't in scope; flag
    for product to define before wiring it to anything real.

## Phase 6 — Coupon module (`nexalink-api` + `nexa_link`)
- Backend: net-new `coupon` module (table, admin CRUD, apply-at-checkout validation
  wired into `OrderService.checkout`), following the `referral_policy`
  admin-configurable-rule convention.
- Frontend: `CouponService` in `nexa_link`, replace `CartNotifier`'s hardcoded
  `NEXA100` check with a real API call.
- Status: **done**. Coupon codes are real end to end: `nexalink-api` gained a
  net-new `coupon` module — `coupon`/`coupon_redemption` tables
  (`V12__create_coupon_tables.sql`), `coupon.application.CouponService`,
  `coupon.api.AdminCouponController` (`hasRole('ADMIN')` CRUD: create/list/deactivate,
  in `coupon.api` rather than `admin.api`, following the
  `wallet.api.AdminWithdrawalController` precedent), and
  `coupon.api.CouponController#validate` (`GET /api/v1/coupons/validate`, a
  no-redemption cart preview). `order.application.OrderService#checkout` re-validates
  the coupon unconditionally and applies it — that's the only place a redemption is
  actually recorded and `times_redeemed` incremented; `orders.coupon_code` /
  `orders.discount_amount` record what was applied. Redemption-constraint assumption
  (nothing in the docs specified this): **one redemption per customer per coupon**,
  enforced by a unique index on `(coupon_id, customer_id)`, independent of a coupon's
  own `max_redemptions` cap across all customers. Frontend: new
  `nexa_link/lib/coupon_service.dart` (`CouponService.validate`);
  `nexa_link/lib/cart_manager.dart`'s `CartNotifier.applyCoupon` is now async and
  calls the backend (removed the hardcoded `NEXA100`/`couponDiscount` constants and
  the stale "no coupon module" doc comment), exposing `isApplyingCoupon`/`couponError`;
  `nexa_link/lib/cart_page.dart` shows a loading spinner on Apply and an error
  snackbar/message on an invalid code; `nexa_link/lib/checkout_page.dart` passes
  `cart.appliedCoupon` through to `OrderService.checkout`'s new `couponCode` param so
  the discount actually reduces the charged total, not just the cart-screen estimate.
  Backend tests: `src/test/java/com/nexalink/backend/coupon/CouponIntegrationTest.java`
  (9 tests — admin CRUD, RBAC 403 for non-admins, invalid/inactive/expired/
  limit-reached/already-used-by-customer previews all 422 with the right error code,
  and checkout actually discounting the total and blocking a second redemption).
  `./gradlew test` and `flutter analyze` both clean.

## Phase 7 — App icon (`nexa_link`)
- Design a brand icon (NexaLink: referral/network + wallet motif), render at
  required resolutions, wire up `flutter_launcher_icons`, regenerate iOS
  `AppIcon.appiconset` and Android `mipmap-*` sets.
- Status: **done**. Custom chain-link glyph (referral/network motif) rendered on the
  app's existing brand gradient (`#5B46FF` → `#6D81FF`, matching the Home/Cart
  gradient cards) via `assets/icon/app_icon.png` (full-bleed, iOS) and
  `app_icon_foreground.png` (transparent, Android adaptive foreground). Wired up via
  `flutter_launcher_icons` in `pubspec.yaml` (`adaptive_icon_background: "#5B46FF"`);
  `dart run flutter_launcher_icons` regenerated both `ios/Runner/Assets.xcassets/AppIcon.appiconset`
  and the Android `mipmap-*`/`drawable-*`/`mipmap-anydpi-v26` adaptive icon sets.
