# Admin Module

Tables

- `role` — id, name (unique), description. Seeded: `CUSTOMER`, `DISTRIBUTOR`, `ADMIN`.
- `permission` — id, name (unique), description. Seeded: `ORDER_PACK`, `ORDER_SHIP`,
  `ORDER_DELIVER`, `WALLET_WITHDRAWAL_APPROVE`, `WALLET_WITHDRAWAL_REJECT`,
  `WALLET_WITHDRAWAL_PAY`.
- `role_permission` — role_id + permission_id (unique pair). `ADMIN` has all six
  permissions; `DISTRIBUTOR` has the three `ORDER_*` ones. Still not enforced anywhere —
  both the Phase 2 (order fulfillment) and Phase 3 (withdrawal admin) routes in
  `../11_Pending_Work_Plan.md` landed gated with plain `@PreAuthorize("hasRole(...))")`/
  `hasAnyRole(...)` checks against the JWT `roles` claim, not against `role_permission`;
  no `PermissionEvaluator` exists to consult it. Wiring one up is still open.
- `user_role` — customer_id + role_id (unique pair). A customer can hold more than one
  role. Every pre-existing customer was backfilled to `CUSTOMER` when this table was
  created so nobody lost access. **Granting or revoking a role is a manual DB
  operation** (`INSERT`/soft-delete on `user_role`) — there is no HTTP endpoint for it;
  that's a future admin-app concern.
- `application_setting` — not created yet. Nothing in the codebase needs a
  key/value config table today; add it (and this doc) when something does.

Implemented in `nexalink-api`'s `V10__create_admin_tables.sql` /
`admin.domain.{Role,Permission,UserRole}` / `admin.application.RoleService` — see
`08_Implementation_Roadmap.md`'s M4 section there for the full write-up, including how
`auth.application.AuthService` resolves a customer's roles into the JWT `roles` claim
at every token issuance and refresh.
