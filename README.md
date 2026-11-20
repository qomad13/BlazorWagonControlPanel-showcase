# VagonLab: wagon processing line control panel (showcase)

A control panel for a railway-wagon processing line that I designed and built end to end. Operators monitor and command two tracks; the system talks to the PLC over Modbus TCP, takes snapshots from RTSP cameras, recognises wagon numbers with a hybrid OCR pipeline (EasyOCR + PaddleOCR), prints labels and reads reference data from an external MySQL database (1C).

> **About this repository.** This is a **sanitized showcase**: architecture, data flow, key decisions (ADRs), configuration examples with placeholders, a database schema and a synthetic seed. It contains **no application source code**, so there is nothing to build or run here. Production code, customer data and infrastructure details are intentionally not included (see [docs/REDACTION.md](docs/REDACTION.md)).
> A walkthrough of the real code is available on a call: ledachkov.ilya@gmail.com

## Stack

| Area | Technology |
|---|---|
| UI | Blazor Server (SignalR circuits), localisation uk/en |
| API | ASP.NET Core controllers, JWT with cookie fallback, role-based policies |
| Data | EF Core, SQLite by default; external MySQL (1C) behind an interface |
| PLC | Modbus TCP, centralised PLC logic engine |
| Cameras / OCR | RTSP snapshots via OpenCvSharp; EasyOCR + PaddleOCR hybrid pipeline |
| Printing | Label templates sent to a network printer over TCP/IP |

## Read this in 5 minutes

1. [`docs/DIAGRAMS.md`](docs/DIAGRAMS.md): components, event sequence and the OCR pipeline (Mermaid).
2. [`docs/KEY_DECISIONS.md`](docs/KEY_DECISIONS.md): the key technical decisions and their trade-offs.
3. [`backend/WHERE_TO_LOOK.md`](backend/WHERE_TO_LOOK.md) and [`frontend/WHERE_TO_LOOK.md`](frontend/WHERE_TO_LOOK.md): where the important code lives in the full application, and why.
4. [`DEMO_INSTRUCTIONS.md`](DEMO_INSTRUCTIONS.md): a suggested 5-minute walkthrough.

## Contents

### Documentation (`docs/`)
- `01-architecture.md`: layers, components, integrations.
- `02-data-flow.md`: the lifecycle of an operator action, from UI to PLC and back.
- `03-multitenancy.md`: multi-tenancy (not used in the current version; notes on how it would be added).
- `04-security.md`: authentication, authorisation and known limitations.
- `05-reliability.md`: error handling, idempotency of PLC commands, background services.
- `DIAGRAMS.md`: Mermaid diagrams.
- `KEY_DECISIONS.md`: key decisions and trade-offs.
- `DEMO_WALKTHROUGH.md`: overview of the functionality.
- `REDACTION.md`: what was removed or replaced, and why.
- `adr/`: architecture decision records (Blazor Server, centralised PLC logic, SQLite by default, hybrid OCR pipeline).

### Code maps
- `backend/WHERE_TO_LOOK.md` and `frontend/WHERE_TO_LOOK.md`: entry points of the full application with a short note on each.

### Configuration and data
- `backend/ENV_EXAMPLE.md`, `appsettings.example.json`: configuration with placeholders only (`CHANGE_ME`).
- `docker-compose.example.yml`: a demo MySQL used to illustrate the external 1C integration.
- `sql/schema_only/core_tables.sql`: the data model (CREATE TABLE only, SQLite syntax).
- `sql/seed_demo.sql`: a synthetic seed.

## Layout of the full application (not included here)

```
Components/   Blazor Server components and pages
Controllers/  ASP.NET Core API controllers
Data/         EF Core DbContext and factory
Models/       data models and DTOs
Plc/          PLC / Modbus logic and drivers
Services/     business logic services
Migrations/   EF Core migrations
Resources/    localisation (uk/en)
wwwroot/      static files (CSS, JS, print templates)
Program.cs    entry point and DI configuration
```

## Limitations of this showcase

- No source code, so no build or run instructions.
- No domains, tokens, real IP addresses or customer data; every sensitive value is replaced with a placeholder.
- Only a safe, generic topology is described; production infrastructure, firewalls, VPN and network ACLs are not documented.
