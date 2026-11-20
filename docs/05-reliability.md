# Reliability

## Error handling and retries

- **Try/catch** wraps every operation that talks to an external system: MySQL (`MySqlOneCService`), RTSP cameras (`SnapshotService`), Modbus (`ModbusProtocol`) and printing (`PrinterService`).
- **Error logging**: exceptions are logged with context for diagnosis.
- **Possible extension**: Polly retry policies with exponential back-off.

## Idempotency

- **PLC commands** are formed from the current state, not from previous commands.
- `PlcLogicEngine` returns `null` when no action is required, which avoids duplicate commands.
- The operating mode and system state are checked before a command is sent.
- **Resend protection**: for critical commands (for example command 12 for the 2→0 transition) a `_sentCommand12` flag prevents sending it again.

## Health checks

- **Start-up check**: the application verifies that the 1C MySQL database is reachable (see `Program.cs`) and logs the result.
- **Possible extension**: a `/health` endpoint covering the database (SQLite/MySQL), the PLC (Modbus), external services (1C) and the state of background tasks.

## Background tasks

- **PlcBusInitializationService** initialises the PLC connection at start-up as a `BackgroundService`. It does not block application start and logs the result.
- **SamplerService** polls the PLC every 5 seconds using `Task.Delay()`. Errors are logged and temporary failures do not stop the loop.
- **OneCConnectionMonitorService** periodically checks the 1C database and logs the status.

## Logging

- **Levels** are configured in `appsettings.json`: `Information` for important events (PLC commands, printing), `Warning`, `Error`, and `Debug` for detailed diagnosis.
- **Context**: logs carry the track number, wagon number and the reason for a command.
- **Format**: built-in .NET logging with parameterised messages.
- **Possible extension**: centralised logging (Serilog + Seq, Application Insights, and similar).

## Fail-safe behaviour

- **Safe commands**: in undesired states the system sends a reset command (command 0), for example when the bridges are down (safety), when there is no acknowledgement from the PLC, or when the mode is unexpected.
- **State checks** before critical operations: bridge masks (all bridges must be up for safe operation), PLC acknowledgements and the track operating mode.
- **Duplicate protection**: critical commands are not sent twice.

## Monitoring and observability

- **Operation logs**: operator actions are stored in `ButtonActions` and print operations in `PrinterLogs`.
- **PLC logs**: every command and response is logged with its reason.
- **Possible metrics**: number of processed wagons, operation times, error rate, availability of external systems.
