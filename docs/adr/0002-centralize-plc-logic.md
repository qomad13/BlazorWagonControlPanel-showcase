# ADR 0002: Centralise PLC logic in one file
- **Context**: operators and PLC engineers change the rules often; a single entry point is needed.
- **Decision**: keep all PLC business logic in `Plc/PlcLogicEngine.cs`.
- **Alternatives**: spread it over services, or use external scripts.
- **Consequences**: easier review and audit, but the file needs discipline and tests as it grows.
