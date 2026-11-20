# ADR 0003: SQLite as the default storage
- **Context**: demos and offline deployments should be simple.
- **Decision**: use SQLite (file `vagonlab.db`) by default in EF Core.
- **Alternatives**: MySQL/PostgreSQL from the start (harder to set up a demo), InMemory (does not keep state).
- **Consequences**: easy to run locally, but scaling is limited; a full database server is expected for larger deployments.
