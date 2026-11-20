# Architecture (high level)

## System components

### Frontend
- **Blazor Server components** (`Components/*`, `Pages/*`): the operator UI.
  - Monitoring of two tracks (Track 1, Track 2)
  - RTSP camera management (16 cameras)
  - Label printing with templates
  - Modbus/PLC, database and printer settings
  - Authentication and user management
- **SignalR**: real-time state updates through Blazor Server circuits.
- **Localisation**: Ukrainian and English (`Resources/SharedResources.*.resx`).

### API layer
**ASP.NET Core controllers** (`Controllers/*`):
- `ProcessController`: commands and status of the production process
- `PlcCommandController`: commands to the PLC over Modbus
- `ModbusSettingsController`: Modbus configuration
- `PrinterController`: label printing and print logs
- `CameraController`: camera management and snapshots
- `AuthController`: authentication and JWT issuing
- `UsersController`: user management
- `SettingsController`: system settings
- `WagonInputController`: wagon data entry
- plus a few other specialised controllers

### Service layer (`Services/*`)
- **Authentication and authorisation**
  - `AuthService`: authentication logic
  - `JwtTokenService`: JWT generation and validation
  - `CustomAuthStateProvider`: authentication state for Blazor
- **PLC / Modbus**
  - `PlcBusFactory`: creates PLC bus instances
  - `PlcBusInitializationService`: background service that initialises the PLC connection at start-up
  - `ModbusConfigurationService`: Modbus configuration
- **Business logic**
  - `ProcessStateService`: state of the wagon processing
  - `ModeComplexLogicService`: transitions between operating modes
  - `TrainCompositionService`: train composition
  - `SamplerService`: sampling and periodic PLC polling
- **Integrations**
  - `IOneCService` / `MySqlOneCService`: integration with the external 1C database (MySQL)
  - `OneCConnectionMonitorService`: connection monitoring
  - `PrinterService`: label printing to a network printer
  - `SnapshotService`: snapshots from RTSP cameras via OpenCvSharp
  - `CameraStubService`: a stub for wagon number recognition (returns "0000000"); in the full system a separate OCR module does this job
- **Helpers**
  - `SettingsService`, `VisibilitySettingsService`, `UserService`, `CultureSyncService`, `TrackUserContext`

### PLC / Modbus (`Plc/*`)
- `PlcBus.cs`: PLC bus abstraction that supports different protocols
- `PlcLogicEngine.cs`: **the single place for PLC business logic** (commands, acknowledgements, mode transitions)
- `ModbusProtocol.cs`: Modbus TCP driver
- `PlcConfiguration.cs`: Modbus register configuration for the tracks
- `TagRef.cs`: references to PLC tags

### Data
**EF Core** (`Data/VagonDbContext.cs`, `Models/*`), SQLite by default (file `vagonlab.db`), migrations in `Migrations/`. Main entities:
- `Users`: users with roles
- `ModbusSettings`, `CameraSettings`, `Settings`: configuration
- `ButtonActions`: operator action log
- `PrinterLogs`: print log
- `ProcessedWagons`: processed wagons
- `ContactInfo`: contact information

### Infrastructure (`Program.cs`)
- DI container setup
- JWT authentication with cookie fallback
- Role-based authorisation (Developer, Administrator, Technician)
- Localisation (uk/en)
- CORS policies
- Blazor Server with SignalR
- PLC initialisation at start-up
- HttpClient with token forwarding (`AuthHeaderHandler`)
- A circuit handler that keeps the culture in sync

## Integrations

### Modbus TCP → PLC
- Polling of status registers (mode, commands, bridge and wagon masks)
- Positioning, hatch and printing commands
- Periodic polling by `PlcBusInitializationService` and `SamplerService`

### MySQL (external 1C database)
- Isolated behind the `IOneCService` interface
- `MySqlOneCService` reads reference data about wagons
- Connection monitored by `OneCConnectionMonitorService`
- The demo setup uses `docker-compose.example.yml` with MySQL

### RTSP cameras and number recognition
- Snapshots via OpenCvSharp (`SnapshotService`)
- Up to 16 cameras (8 per track); settings stored in the database (`CameraSettings`)
- **OCR module** (separate from this showcase, replaced by a stub here):
  - Hybrid EasyOCR + PaddleOCR pipeline for wagon numbers
  - EasyOCR quickly finds the number areas on a Full HD image
  - PaddleOCR reads the digits in those areas (good accuracy on damaged wagons)
  - About 1 second per Full HD frame
  - Here it is replaced by `CameraStubService`, which returns "0000000" to illustrate the architecture

### Label printing
- Templates in `wwwroot/prn-templates/*.prn`
- Network printer over TCP/IP (port 9100)
- Every print operation is logged in `PrinterLogs`

## Data flows

1. **UI → API**: Blazor components call controllers through HttpClient with a JWT.
2. **API → Services**: controllers delegate business logic to services.
3. **Services → PLC**: commands are formed in `PlcLogicEngine` and sent through `PlcBus`.
4. **PLC → Services**: PLC data is polled periodically and processed by `PlcLogicEngine`.
5. **Services → DB**: operations are logged and stored through EF Core in SQLite.
6. **DB → UI**: state is pushed to the browser through Blazor Server SignalR circuits.

## Design notes

- **Centralised PLC logic**: all PLC business logic is in one file, `PlcLogicEngine.cs`, so changes stay easy to find.
- **Separation of concerns**: clear boundaries between UI, API, services and data.
- **Dependency inversion**: interfaces such as `IOneCService` and `IPlcBusFactory` keep components testable.
- **Background tasks**: `BackgroundService` for periodic work (PLC polling, connection monitoring).
