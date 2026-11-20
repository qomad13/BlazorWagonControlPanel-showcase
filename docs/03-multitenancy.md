# Multi-tenancy

Not used in the current version. The system is single-tenant: one site, one database, one set of roles.

If multi-tenancy were needed:
- Routing by sub-domain or an `X-Tenant-Id` header.
- A separate schema or database per tenant (SQLite/MySQL), mapped through an `ITenantProvider`.
- Isolation of caches and Modbus/PLC settings per tenant.
