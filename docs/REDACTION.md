# Redaction policy (showcase)

## What was removed or replaced

### Sensitive data
- **Passwords**: all real passwords are replaced with the placeholder `CHANGE_ME` (database passwords in configuration and defaults, RTSP passwords in UI placeholders).
- **Tokens and keys**: JWT secret keys are replaced with placeholders.
- **IP addresses**: real addresses are replaced with `127.0.0.1` or `CHANGE_ME_IP` (PLC, printer, camera RTSP URLs).
- **Domains**: real domains are not included in the documentation.
- **Server paths**: paths on production servers are not documented.

### Configuration
- **appsettings.example.json**: an example with `CHANGE_ME` placeholders and illustrative Modbus register numbers.
- **docker-compose.example.yml**: a demo configuration with `CHANGE_ME` passwords.
- **ENV examples**: `backend/ENV_EXAMPLE.md` contains placeholders only.

### Data
- **Customer data**: not included in the seed or examples.
- **Operation logs**: no real customer data.
- **Seed**: fully synthetic (`sql/seed_demo.sql`).

### Infrastructure
- Production topologies, firewall rules, VPN configuration, network ACLs and monitoring/alert configuration are not documented.

## What was kept (neutral examples)

- **Local addresses**: `127.0.0.1` in demo configuration.
- **Demo RTSP placeholders**: values like `rtsp://demo:demo@localhost:554/stream`.
- **Standard ports**: 502 (Modbus), 3306/3307 (MySQL), 9100 (printer).
- **Database structure**: table schemas without real data.

## Files excluded from the showcase

1. All application source code.
2. `appsettings.json` and `appsettings.*.local.json`.
3. `.env*` files.
4. Build output (`bin/`, `obj/`).
5. Database files (`*.db`, `*.sqlite`).
6. Temporary state and dump files.

## Pre-publication check

Before each publication the showcase is checked manually: a search for passwords, tokens and keys, a search for real IP addresses (only `127.0.0.1` and `localhost` are allowed), and a review of the commit history for secrets. There are no automated checks in CI in this repository.
