# ADR 0001: Use Blazor Server
- **Context**: a fast UI with real-time PLC/Modbus state updates, without a heavy SPA.
- **Decision**: Blazor Server + SignalR.
- **Alternatives**: React SPA + Web API + WebSocket (more front-end infrastructure), Blazor WebAssembly (larger download).
- **Consequences**: depends on a stable connection, but a smaller bundle and a faster time-to-demo.
