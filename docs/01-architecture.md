# Архитектура (high-level)

## Компоненты системы

### Frontend
- **Blazor Server компоненты** (`Components/*`, `Pages/*`) — UI для операций:
  - Мониторинг двух треков (Track 1, Track 2)
  - Управление камерами RTSP (16 камер)
  - Печать ярлыков с шаблонами
  - Настройки Modbus/PLC, БД, принтера
  - Аутентификация и управление пользователями
- **SignalR** — real-time обновления состояния через Blazor Server circuits
- **Локализация** — поддержка украинского и английского языков (`Resources/SharedResources.*.resx`)

### API Layer
- **ASP.NET Core Controllers** (`Controllers/*`):
  - `ProcessController` — команды и статусы производственного процесса
  - `PlcCommandController` — команды к PLC через Modbus
  - `ModbusSettingsController` — управление конфигурацией Modbus
  - `PrinterController` — печать ярлыков и логи печати
  - `CameraController` — управление камерами и снимки
  - `AuthController` — аутентификация и выдача JWT токенов
  - `UsersController` — управление пользователями
  - `SettingsController` — системные настройки
  - `WagonInputController` — ввод данных о вагонах
  - И другие специализированные контроллеры

### Сервисный слой (`Services/*`)
- **Аутентификация/Авторизация**:
  - `AuthService` — логика аутентификации
  - `JwtTokenService` — генерация и валидация JWT токенов
  - `CustomAuthStateProvider` — провайдер состояния аутентификации для Blazor
- **PLC/Modbus**:
  - `PlcBusFactory` — фабрика для создания экземпляров PLC шины
  - `PlcBusInitializationService` — фоновый сервис инициализации PLC при старте
  - `ModbusConfigurationService` — управление конфигурацией Modbus
- **Бизнес-логика**:
  - `ProcessStateService` — управление состоянием процесса обработки вагонов
  - `ModeComplexLogicService` — логика переходов между режимами работы
  - `TrainCompositionService` — работа с составом поезда
  - `SamplerService` — сервис пробоотбора
- **Интеграции**:
  - `IOneCService` / `MySqlOneCService` — интеграция с внешней БД 1C (MySQL)
  - `OneCConnectionMonitorService` — мониторинг соединения с БД 1C
  - `PrinterService` — печать ярлыков на сетевой принтер
  - `SnapshotService` — получение снимков с RTSP камер через OpenCvSharp
  - `CameraStubService` — заглушка для распознавания номеров вагонов (выдаёт "0000000", заменяет отдельный OCR модуль)
- **Вспомогательные**:
  - `SettingsService` — управление системными настройками
  - `VisibilitySettingsService` — настройки видимости элементов UI
  - `UserService` — управление пользователями
  - `CultureSyncService` — синхронизация культуры между компонентами
  - `TrackUserContext` — контекст пользователя для треков

### PLC/Modbus (`Plc/*`)
- **`PlcBus.cs`** — абстракция шины PLC, поддерживает разные протоколы
- **`PlcLogicEngine.cs`** — **единая точка бизнес-логики PLC** (команды, подтверждения, переходы между режимами)
- **`ModbusProtocol.cs`** — драйвер Modbus TCP
- **`PlcConfiguration.cs`** — конфигурация регистров Modbus для треков
- **`TagRef.cs`** — ссылки на теги PLC

### Данные
- **EF Core** (`Data/VagonDbContext.cs`, `Models/*`):
  - SQLite по умолчанию (файл `vagonlab.db`)
  - Миграции в `Migrations/`
  - Основные сущности:
    - `Users` — пользователи с ролями
    - `ModbusSettings` — настройки Modbus/PLC
    - `CameraSettings` — настройки камер
    - `ButtonActions` — логи действий оператора
    - `PrinterLogs` — логи печати
    - `ProcessedWagons` — обработанные вагоны
    - `Settings` — системные настройки
    - `ContactInfo` — контактная информация

### Инфраструктура (`Program.cs`)
- Настройка DI контейнера
- JWT аутентификация с cookie fallback
- Авторизация по ролям (Developer, Administrator, Technician)
- Локализация (uk/en)
- CORS политики
- Blazor Server с SignalR
- Инициализация PLC при старте
- HttpClient с прокладкой токена (`AuthHeaderHandler`)
- Circuit handler для синхронизации культуры

## Интеграции (демо)

### Modbus TCP → PLC
- Опрос регистров состояния (режим, команды, маски мостов/вагонов)
- Отправка команд позиционирования, управления люками, печати
- Периодический опрос через `PlcBusInitializationService` и `SamplerService`

### MySQL (внешняя БД 1C)
- Изолировано через интерфейс `IOneCService`
- Реализация `MySqlOneCService` для чтения справочных данных о вагонах
- Мониторинг соединения через `OneCConnectionMonitorService`
- В демо используется `docker-compose.example.yml` с MySQL

### Камеры RTSP и распознавание номеров
- Получение снимков через OpenCvSharp (`SnapshotService`)
- Поддержка до 16 камер (8 на трек)
- Настройки камер хранятся в БД (`CameraSettings`)
- **OCR модуль** (отдельный модуль, заменён заглушкой в showcase):
  - Гибридный пайплайн EasyOCR + PaddleOCR для распознавания номеров вагонов
  - EasyOCR быстро определяет области с номерами на full HD изображении
  - PaddleOCR распознаёт цифры по найденным областям (высокая точность на битых вагонах)
  - Время обработки: ~1 секунда на кадр full HD
  - В showcase заменён на `CameraStubService`, выдающий "0000000" для демонстрации архитектуры

### Печать ярлыков
- Шаблоны в `wwwroot/prn-templates/*.prn`
- Сетевой принтер через TCP/IP (порт 9100)
- Логирование всех операций печати в `PrinterLogs`

## Потоки данных

1. **UI → API**: Blazor компоненты вызывают контроллеры через HttpClient с JWT токеном
2. **API → Services**: Контроллеры делегируют бизнес-логику сервисам
3. **Services → PLC**: Команды формируются в `PlcLogicEngine` и отправляются через `PlcBus`
4. **PLC → Services**: Данные с PLC опрашиваются периодически и обрабатываются `PlcLogicEngine`
5. **Services → DB**: Все операции логируются и сохраняются через EF Core в SQLite
6. **DB → UI**: Состояние обновляется через Blazor Server SignalR circuits

## Особенности архитектуры

- **Централизованная PLC-логика**: вся бизнес-логика для PLC находится в одном файле `PlcLogicEngine.cs` для упрощения изменений
- **Разделение ответственности**: четкое разделение между UI, API, сервисами и данными
- **Инверсия зависимостей**: использование интерфейсов (`IOneCService`, `IPlcBusFactory`) для тестируемости
- **Фоновые задачи**: использование `BackgroundService` для периодических операций (опрос PLC, мониторинг соединений)

