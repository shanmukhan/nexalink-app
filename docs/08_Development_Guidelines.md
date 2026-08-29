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

## Git
- Feature branches
- Pull Requests
- Code Reviews

## Testing
- Unit
- Widget
- Integration
