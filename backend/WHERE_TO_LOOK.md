# Backend: entry points (full app, not included in this repository)

- `Program.cs`: DI configuration, authentication/authorisation, Blazor Server, PLC initialisation.
- `Controllers/ProcessController.cs`: commands and status of the production process.
- `Controllers/ModbusSettingsController.cs`: Modbus/PLC configuration.
- `Controllers/PrinterController.cs`: label printing and print logs.
- `Controllers/CameraController.cs`: camera control and wagon number recognition.
- `Controllers/AuthController.cs` + `Services/JwtTokenService.cs`: token issuing, roles.
- `Plc/PlcLogicEngine.cs`: the single place for PLC business logic (commands/acks).
- `Services/PlcBusFactory.cs` + `Plc/PlcBus.cs`: creating and running the PLC/Modbus bus.
- `Services/CameraStubService.cs`: stub for number recognition (returns "0000000"); stands in for the separate OCR module with the EasyOCR + PaddleOCR hybrid pipeline.
- `Services/SnapshotService.cs`: snapshots from RTSP cameras through OpenCvSharp.
- `Data/VagonDbContext.cs` + `Migrations/*`: data model and migrations.
