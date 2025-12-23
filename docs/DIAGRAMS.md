# Диаграммы (Mermaid)

## Компоненты
```mermaid
flowchart LR
  UI[Blazor UI] --> API[ASP.NET Core API]
  API --> Services[Сервисы]
  Services --> PLC[PLC/Modbus]
  Services --> DB[SQLite EF Core]
  Services --> OneC[MySQL 1C (демо)]
  Services --> Print[Принтер]
  Services --> Camera[RTSP Камеры]
```

## Поток события (sequence)
```mermaid
sequenceDiagram
  participant Operator
  participant UI as Blazor UI
  participant API as API Controller
  participant S as Services
  participant PLC as PLC/Modbus
  Operator->>UI: Нажимает действие
  UI->>API: POST /action (JWT)
  API->>S: Validate + authorize
  S->>PLC: Команда (через PlcBus)
  S-->>API: Результат/лог
  API-->>UI: Ответ
  UI-->>Operator: Обновлённый статус
```

## OCR пайплайн (EasyOCR + PaddleOCR)
```mermaid
sequenceDiagram
  participant Camera as RTSP Camera
  participant Snapshot as SnapshotService
  participant EasyOCR as EasyOCR<br/>(Детекция)
  participant PaddleOCR as PaddleOCR<br/>(Распознавание)
  participant System as Система
  
  Camera->>Snapshot: Full HD снимок
  Snapshot->>EasyOCR: Полное изображение
  EasyOCR->>EasyOCR: Поиск областей<br/>с номерами
  EasyOCR->>PaddleOCR: Области интереса<br/>(crops)
  PaddleOCR->>PaddleOCR: Распознавание цифр
  PaddleOCR->>System: Номера вагонов<br/>(~1 сек на кадр)
```

