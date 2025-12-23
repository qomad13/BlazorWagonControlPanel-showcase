# ADR 0001: Использовать Blazor Server
- **Контекст**: нужен быстрый UI с real-time обновлением состояния PLC/Modbus без тяжёлого SPA.
- **Решение**: Blazor Server + SignalR.
- **Альтернативы**: React/SPA + WebAPI + WebSocket (больше фронтенд-инфры), Blazor WebAssembly (больше загрузка).
- **Последствия**: зависимость от стабильного соединения, но меньше бандл и быстрее time-to-demo.

