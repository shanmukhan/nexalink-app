# Development Guidelines

## Flutter
- Stateful widgets + `InheritedNotifier` (`CartProvider`) for shared state — no Riverpod/GoRouter/Dio/Freezed in the codebase currently
- `package:http` via `lib/api_client.dart` for all backend calls
- `flutter_localizations` / `.arb` files for i18n (English + Telugu)

## Backend
- Spring Boot (Java 21, Gradle Kotlin DSL), PostgreSQL, Redis — lives in the sibling `nexalink-api` repo, not this one (see [07_Project_Structure.md](07_Project_Structure.md))

## Running the backend locally (for testing the app against real APIs)

From the `nexalink-api` repo:

```bash
docker compose up -d          # Postgres + Redis
JAVA_HOME=$(/usr/libexec/java_home -v 21) ./gradlew bootRun
```

- Requires JDK 21 specifically — Gradle 8.10.2 (this project's wrapper version) fails
  to start on newer JDKs (e.g. 25), so pin `JAVA_HOME` if that's your system default.
- Health check: http://localhost:8080/actuator/health

### Pointing the Flutter app at it

`lib/api_client.dart`'s `kApiBaseUrl` defaults to `http://10.0.2.2:8080/api/v1`,
which only resolves on the **Android emulator** (it's an alias to the host machine's
localhost from inside the emulator). For any other target, override it:

```bash
# iOS simulator / macOS / web — backend on localhost works directly
flutter run --dart-define=API_BASE_URL=http://localhost:8080/api/v1

# Physical Android/iOS device — use the host machine's LAN IP instead, and make
# sure the device is on the same Wi-Fi network as the machine running the backend
flutter run --dart-define=API_BASE_URL=http://<host-LAN-IP>:8080/api/v1
```

## Release builds (Google Play)

The app is signed for release with an **upload keystore** at `android/app/upload-keystore.jks`,
configured via `android/key.properties` (both gitignored — never commit them). `android/app/build.gradle.kts`
loads `key.properties` if present and signs `release` builds with it; if the file is missing (e.g. a fresh
checkout on another machine), it falls back to the debug key so `flutter run --release` still works locally.

**The keystore + its password (in `key.properties`) only exist on this machine.** Back both up somewhere
durable (password manager, encrypted drive) before doing anything that could wipe this checkout — Google Play
requires the *same* upload key for every future update to this `applicationId`; losing it means going through
Google's account-recovery process to re-establish a new upload key.

To build the release App Bundle for Play Console submission:

```bash
flutter build appbundle --release
# → build/app/outputs/bundle/release/app-release.aab
```

To build a signed release APK instead (for direct install/testing, not for Play Console):

```bash
flutter build apk --release
# → build/app/outputs/apk/release/app-release.apk
```

See [10_Play_Store_Listing.md](10_Play_Store_Listing.md) for the listing content (app name, package name,
descriptions, screenshots) to pair with the build.

### Version bump convention

`pubspec.yaml`'s `version:` line is `<versionName>+<versionCode>`, e.g. `1.0.1+1`. **When asked to "bump the
version," increment both halves together, in lockstep** — the patch number before `+` by 1, and the build
number after `+` by 1 — so they never drift apart (e.g. `1.0.1+1` → `1.0.2+2` → `1.0.3+3`). Don't bump only
one half. After bumping, rebuild the release artifact (`flutter build appbundle --release`) so the shipped
build matches the new version.

## Git
- Feature branches
- Pull Requests
- Code Reviews

## Testing
- Unit
- Widget
- Integration
