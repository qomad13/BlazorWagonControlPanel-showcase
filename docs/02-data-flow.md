# Data flow: lifecycle of an event

## Typical scenario: an operator starts wagon positioning

### 1. Action in the UI
- The operator presses "Start positioning" on the `Process.razor` page.
- The Blazor component calls the API through `HttpClient` with the JWT in the header.
- The request goes to `POST /api/process/start-positioning`.

### 2. Handling in the API controller
- `ProcessController.StartPositioning()` receives the request.
- The JWT is checked through the `[Authorize]` attribute.
- The role is checked (for example `TechnicianPolicy`).
- Input is validated (track number, wagon number).

### 3. Business logic in the services

#### PLC commands
- `ProcessController` calls `PlcLogicEngine.ProcessIncomingData()` with the current state.
- `PlcLogicEngine` analyses the operating mode, bridge and wagon masks and acknowledgements.
- A command (`OutgoingCommand`) is formed with the track number and a command code (for example 100 for Track 1).
- The command is sent through `PlcBus.WriteCommand()` → `ModbusProtocol.WriteRegister()`.
- The reason for the command and the result are logged.

#### Printing
- `PrinterController` calls `PrinterService.PrintLabel()`.
- The service loads the template from `wwwroot/prn-templates/track{N}.prn`.
- Placeholders are replaced with wagon data.
- The data is sent to the network printer over TCP/IP (port 9100).
- The operation is logged in `PrinterLogs` through EF Core.

#### Cameras and number recognition
- `CameraController` calls `SnapshotService.CaptureSnapshot()`.
- The service reads the RTSP URL from `CameraSettings` (database) and grabs a frame with OpenCvSharp.
- The snapshot is saved and its URL is returned to the UI.
- For number recognition, `CameraController` calls `CameraStubService.RecognizeWagonNumbersAsync()`.
- In the full system a separate OCR module (EasyOCR + PaddleOCR pipeline) does the recognition.
- In this showcase `CameraStubService` returns "0000000" to illustrate the architecture.

#### Settings
- `SettingsService` or `ModbusConfigurationService` save changes through EF Core.
- The matching table is updated (`ModbusSettings`, `CameraSettings`, `Settings`).

#### 1C integration
- `MySqlOneCService.GetWagonData()` runs a parameterised SQL query against MySQL.
- It reads from the `wagon_data` table (wagon number, weight, status).
- It returns a DTO for the UI.

### 4. Persistence
EF Core (`VagonDbContext`) saves changes to SQLite:
- `ButtonActions`: operator action log
- `PrinterLogs`: print log
- `ModbusSettings`, `CameraSettings`, `Settings`: settings updates
- `ProcessedWagons`: processed wagons

Transactions keep the data consistent.

### 5. UI update
- The Blazor Server SignalR circuit receives the state update.
- Components re-render automatically when data changes.
- `CultureSyncService` keeps the culture in sync between components.
- The operator sees the updated track status, print log and camera snapshots.

### 6. Background processes

#### PLC polling
- `PlcBusInitializationService` initialises the PLC connection at application start.
- `SamplerService` polls the Modbus registers periodically (every 5 seconds):
  - reads the operating mode, commands and bridge/wagon masks
  - calls `PlcLogicEngine.ProcessIncomingData()` with the result
  - `PlcLogicEngine` analyses the state and may send a command on its own
  - results are logged and update the state in `ProcessStateService`

#### Connection monitoring
- `OneCConnectionMonitorService` periodically checks that the 1C MySQL database is reachable and logs the status.

## Reverse flow: PLC → UI

1. **The PLC updates** its Modbus registers.
2. **`SamplerService` polls** the registers every N seconds.
3. **`PlcBus.ReadRegisters()`** reads the current state.
4. **`PlcLogicEngine.ProcessIncomingData()`** processes it:
   - determines the operating mode (Waiting, Positioning, Sampling)
   - detects bit edges (end of positioning, print button)
   - may send a command automatically (for example a switch to Sampling)
5. **`ProcessStateService`** updates the internal state.
6. **The UI updates** through Blazor Server SignalR.

## Notes

- **Idempotency**: PLC commands are formed from the current state; `PlcLogicEngine` returns `null` when no action is needed.
- **Logging**: all operations are logged for audit and debugging.
- **Error handling**: try/catch at every level; errors are logged and returned to the UI.
- **Async**: most operations use async/await so that nothing blocks.
