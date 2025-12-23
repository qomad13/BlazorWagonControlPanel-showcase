# Backend — точки входа

- `Program.cs` — конфигурация DI, аутентификация/авторизация, Blazor Server, инициализация PLC.
- `Controllers/ProcessController.cs` — команды и статусы производственного процесса.
- `Controllers/ModbusSettingsController.cs` — управление конфигом Modbus/PLC.
- `Controllers/PrinterController.cs` — печать ярлыков и логи печати.
- `Controllers/CameraController.cs` — управление камерами и распознавание номеров вагонов.
- `Controllers/AuthController.cs` + `Services/JwtTokenService.cs` — выдача токенов, роли.
- `Plc/PlcLogicEngine.cs` — единая точка бизнес-логики PLC (команды/acks).
- `Services/PlcBusFactory.cs` + `Plc/PlcBus.cs` — создание и работа шины PLC/Modbus.
- `Services/CameraStubService.cs` — заглушка для распознавания номеров (выдаёт "0000000", заменяет отдельный OCR модуль с гибридным пайплайном EasyOCR + PaddleOCR).
- `Services/SnapshotService.cs` — получение снимков с RTSP камер через OpenCvSharp.
- `Data/VagonDbContext.cs` + `Migrations/*` — модель данных и миграции.

