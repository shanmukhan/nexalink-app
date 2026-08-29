# Project Structure

The customer app and backend are separate sibling repos on disk (not a monorepo):

```text
repo/
├── nexa_link/            (this repo) Flutter customer app + product/requirements docs
│   ├── docs/
│   └── lib/
└── nexalink-api/          Spring Boot backend (Java 21, Gradle) — see its own docs/
    ├── docs/
    └── src/
```

`flutter_distributor` and `flutter_admin` apps and a dedicated `deployment/` repo
don't exist yet — planned for later phases (see
[09_Project_Roadmap.md](09_Project_Roadmap.md)).
