# Walkthrough guide: 5 minutes

This repository contains documentation only, so the walkthrough is a guided read. A live walkthrough of the full application is available on a call.

## Suggested route

### 1. Architecture and layers (1 minute)
- Layout of the full application: `Components/` (UI), `Controllers/` (API), `Services/` (business logic), `Plc/` (PLC logic). See the README.
- The path of a command: UI → API → Services → PLC (`docs/DIAGRAMS.md`).
- PLC rules live in one place: `PlcLogicEngine.cs`.

### 2. Key technical decisions (1 minute)
- **Blazor Server**: real-time UI over SignalR, one C# codebase.
- **Hybrid OCR pipeline**: EasyOCR finds the number areas, PaddleOCR reads the digits; about 1 second per Full HD frame.
- **SQLite by default**: simple local setup; migration to PostgreSQL/MySQL for scaling.
- **JWT with cookie fallback**: convenient for Blazor page reloads.

### 3. Integrations and data flow (1 minute)
- Modbus PLC: register polling and commands (`docs/02-data-flow.md`).
- External MySQL (1C): reference data about wagons, behind an interface.
- Logging of operator actions and printing; background services for polling and connection monitoring.

### 4. Functionality (1-2 minutes)
- `docs/DEMO_WALKTHROUGH.md`: the pages (home, developer settings, operations, printing) and what an operator can do.

## Optional: look at the data model

```bash
sqlite3 vagonlab.db < sql/schema_only/core_tables.sql
sqlite3 vagonlab.db < sql/seed_demo.sql
```

The optional demo MySQL for the 1C integration: `docker compose -f docker-compose.example.yml up -d`.

## Topics for discussion

- **Architecture**: why Blazor Server instead of an SPA; why a hybrid OCR pipeline; why SQLite by default; why PLC logic is centralised in one file.
- **Scalability**: SignalR backplane for horizontal scaling, moving the database to PostgreSQL/MySQL, separation of layers.
- **Reliability**: error handling, idempotent PLC commands, background tasks and monitoring.
- **Security**: JWT with role-based policies, parameterised queries (see docs/04-security.md for known limitations).
