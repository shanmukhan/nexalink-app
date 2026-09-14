# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

NexaLink customer app: a Flutter (Android/iOS) app for a product distribution and referral
platform (single-product MVP, referral-based acquisition, wallet cashback). This repo holds only
the Flutter customer app plus product/requirements docs — the backend is a separate sibling repo,
`nexalink-api` (Spring Boot, Java 21, Gradle), not part of this checkout. `flutter_distributor` and
`flutter_admin` apps don't exist yet (planned, see `docs/09_Project_Roadmap.md`).

## Commands

```bash
flutter pub get              # install dependencies
flutter analyze              # lint (flutter_lints, see analysis_options.yaml)
flutter test                 # run all tests
flutter test test/widget_test.dart   # run a single test file
flutter run                  # run the app (defaults to Android emulator API URL)
flutter gen-l10n             # regenerate lib/generated/app_localizations*.dart after editing .arb files
```

### Pointing the app at a local backend

`kApiBaseUrl` in [lib/api_client.dart](lib/api_client.dart) defaults to `http://10.0.2.2:8080/api/v1`,
which only resolves from the **Android emulator**. Override for other targets:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:8080/api/v1          # iOS sim / macOS / web
flutter run --dart-define=API_BASE_URL=http://<host-LAN-IP>:8080/api/v1      # physical device
```

To run the backend itself, see `nexalink-api`'s own docs (from that repo: `docker compose up -d`
then `JAVA_HOME=$(/usr/libexec/java_home -v 21) ./gradlew bootRun` — requires JDK 21 specifically).

### Release builds

```bash
flutter build appbundle --release   # → build/app/outputs/bundle/release/app-release.aab (Play Console)
flutter build apk --release         # → build/app/outputs/apk/release/app-release.apk (direct install)
```

Signed with an upload keystore at `android/app/upload-keystore.jks` via `android/key.properties`
(both gitignored, exist only on this machine — back them up; losing the upload key requires
Google's account-recovery process). Missing `key.properties` falls back to the debug key so
`flutter run --release` still works on a fresh checkout.

**Version bump convention**: `pubspec.yaml`'s `version:` is `<versionName>+<versionCode>`. When
asked to "bump the version," increment both halves together in lockstep (e.g. `1.0.1+1` →
`1.0.2+2`), never just one.

## Architecture

**Important discrepancy**: [.ai/project_rules.md](.ai/project_rules.md) prescribes Clean
Architecture / Feature-First / Riverpod / GoRouter / Dio / Freezed for new AI-assisted work, but
none of that is actually in the codebase yet. The current, real pattern (per
[docs/08_Development_Guidelines.md](docs/08_Development_Guidelines.md)) is:

- Flat `lib/` with `StatefulWidget`s + `InheritedNotifier` for shared state (`CartProvider` /
  `CartNotifier` in [lib/cart_manager.dart](lib/cart_manager.dart), `LocaleProvider` /
  `LocaleNotifier` in [lib/locale_manager.dart](lib/locale_manager.dart)) — no Riverpod/GoRouter/
  Dio/Freezed anywhere currently.
- One `*_service.dart` per backend resource (`auth_service.dart`, `order_service.dart`,
  `wallet_service.dart`, `coupon_service.dart`, `catalog_service.dart`, `address_service.dart`,
  `referral_service.dart`), each a thin class calling through `ApiClient`.
- One `*_page.dart` per screen, navigated with plain `Navigator` (no router package).
- Match the existing pattern unless told otherwise — don't introduce Riverpod/GoRouter/Dio/Freezed
  unprompted just because `.ai/project_rules.md` mentions them.

### Networking layer

[lib/api_client.dart](lib/api_client.dart) is a singleton (`ApiClient.instance`) wrapping
`package:http` for all calls to `nexalink-api`'s `/api/v1` endpoints:
- Unwraps the backend's `{success, data, error}` envelope, throwing `ApiException` on failure.
- Attaches the bearer access token automatically; persists access/refresh tokens and a generated
  device identifier via `shared_preferences` across launches (`loadSession`/`saveSession`/
  `clearSession`).
- Service classes call `ApiClient.instance.get/post/put/delete(path, parseFn)` and pass a parser
  from [lib/api_models.dart](lib/api_models.dart) DTOs.

### Cart / checkout flow

`CartNotifier` ([lib/cart_manager.dart](lib/cart_manager.dart)) is the one non-trivial piece of
state management — read its file-level doc comment before touching checkout/wallet/coupon logic.
Key points:
- Cart state is backed by a DRAFT `orders` row on the backend (`/api/v1/cart`), not local-only
  state.
- Coupon codes are validated twice: client-side preview via `/api/v1/coupons/validate`, then
  re-validated unconditionally server-side during `/orders/checkout` — the server re-validation is
  what actually changes the charged amount.
- Wallet balance can only pay for an order **all-or-nothing**: if it fully covers the subtotal,
  checkout uses the `WALLET` payment method and really debits the ledger; a partial balance is
  estimate-only, since the backend's order model supports only one payment method per order.

### Localization

English + Telugu via `flutter_localizations` and `.arb` files in `lib/l10n/` (`app_en.arb` is the
template, per [l10n.yaml](l10n.yaml)). Generated code lives in `lib/generated/` — regenerate with
`flutter gen-l10n` after editing `.arb` files; never hand-edit the generated files. Per
[.ai/project_rules.md](.ai/project_rules.md), never hardcode user-facing strings — add to the
`.arb` files instead.

## Documentation

`docs/` is the source of truth for product/business requirements, database schema, system
architecture, and UI specs (see `docs/07_Project_Structure.md` for the full map; `docs/database/`
mirrors the backend's schema even though the backend code lives in the sibling repo). Per standing
project instructions, update the relevant `docs/*.md` file whenever a code change affects what it
describes.
