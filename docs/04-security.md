# Security

This page describes how the application handles security and, just as important, which parts are demo-level defaults that need hardening for a real deployment.

## Authentication

- **JWT Bearer tokens** authenticate API requests.
  - The token is generated in `JwtTokenService` after a successful login.
  - The secret key comes from configuration (environment variables in a real deployment).
  - The token can also be read from the `AuthToken` cookie, which keeps Blazor working across page reloads.
  - Validation is configured in `Program.cs` through `JwtBearerOptions`.
- **Password storage**: BCrypt hashes in `Users.Password` (library `BCrypt.Net-Next`). Passwords are never stored in clear text. The seed contains synthetic hashes only.

## Authorisation

- **Roles**: `Developer` (full access), `Administrator` (administrative functions), `Technician` (operator functions).
- **Policies** (configured in `Program.cs`): `DeveloperPolicy`, `AdministratorPolicy`, `TechnicianPolicy`, and `AdminsAndDevelopers` for sensitive operations.
- **Usage**: controllers protect endpoints with `[Authorize(Policy = "...")]`.

## Input validation

- **DataAnnotations** on the models (`[Required]`, `[MaxLength]`, and so on).
- **Localised errors**: a custom `CustomLocalizedDataAnnotationsValidator` shows validation messages in Ukrainian or English.

## Transport security

- The demo setup uses plain HTTP so that it is easy to start.
- A real deployment should run behind HTTPS with valid certificates.
- Mutual TLS for integrations with external systems is possible but not enabled.

## Secrets management

- Sensitive values (passwords, keys) belong in environment variables or `.env` files. See `backend/ENV_EXAMPLE.md` and `appsettings.example.json`.
- This repository contains no real secrets; all of them are replaced with `CHANGE_ME` (see `docs/REDACTION.md`).

## CORS

- The demo configuration allows any origin, method and header for simplicity.
- A real deployment should restrict origins, methods and headers (`AddCors()` in `Program.cs`).

## Injection protection

- **SQL injection**: EF Core uses parameterised queries by default, and `MySqlOneCService` uses parameterised SQL.
- **XSS**: Blazor escapes HTML output automatically.

## Known limitations (to harden before a real deployment)

- **CSRF**: there is no dedicated anti-forgery protection. API calls rely on a Bearer token in the header; because the token can also come from a cookie, a real deployment should set the cookie flags (HttpOnly, Secure, SameSite) and consider anti-forgery tokens.
- **CORS and HTTPS**: see the sections above; the demo defaults are intentionally permissive.
- **Rate limiting and account lockout**: not implemented.

## PLC / Modbus attack surface

- **Isolation**: the API does not expose raw Modbus registers.
- **Command validation**: every command goes through `PlcLogicEngine`, which checks the current operating mode, the bridge state (safety), acknowledgements from the PLC and mode transitions.
- **Logging**: every command is logged together with its reason, for audit.
