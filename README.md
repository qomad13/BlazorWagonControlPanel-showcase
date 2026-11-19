# VagonLab Showcase

> **English summary.** VagonLab is a control panel for a railway-wagon processing line, built with Blazor Server, ASP.NET Core and EF Core. It talks to PLCs over Modbus, shows RTSP camera feeds, recognises wagon numbers with a hybrid OCR pipeline (EasyOCR + PaddleOCR), prints labels and syncs with an external MySQL database. Access is role-based (Developer / Administrator / Technician). I designed and built it end to end.
>
> This repository is a **sanitized showcase**: architecture, data flow, key decisions and configuration examples with placeholders. Production code, customer data and infrastructure details are intentionally not included (see [docs/REDACTION.md](docs/REDACTION.md)). Walkthrough on a call: ledachkov.ilya@gmail.com


## TL;DR

- **Панель управления вагонным участком**: SCADA-система для управления производственным процессом обработки вагонов с интеграцией Modbus/PLC, камерами RTSP, гибридным OCR пайплайном (EasyOCR + PaddleOCR) и печатью ярлыков.
- **Технологический стек**: Blazor Server + ASP.NET Core API + EF Core (SQLite по умолчанию) + интеграция с внешней БД 1C (MySQL).
- **Основные сценарии**: мониторинг двух треков, управление мостами/люками, автоматическое позиционирование, распознавание номеров вагонов через OCR, учёт печати, базовая аутентификация по ролям (Developer/Administrator/Technician).

## Что посмотреть за 3–5 минут

1. **[`docs/DIAGRAMS.md`](docs/DIAGRAMS.md)** — визуализация компонентов, поток данных, последовательность событий (Mermaid-диаграммы).
2. **[`docs/KEY_DECISIONS.md`](docs/KEY_DECISIONS.md)** — 5–7 ключевых технических решений и компромиссов.
3. **[`backend/WHERE_TO_LOOK.md`](backend/WHERE_TO_LOOK.md)** и **[`frontend/WHERE_TO_LOOK.md`](frontend/WHERE_TO_LOOK.md)** — быстрые точки входа в код с пояснениями.
4. **[`DEMO_INSTRUCTIONS.md`](DEMO_INSTRUCTIONS.md)** — пошаговая демонстрация за 5 минут.

## Состав витрины

### Документация (`docs/`)
- **`01-architecture.md`** — high-level архитектура, компоненты, интеграции.
- **`02-data-flow.md`** — путь данных, жизненный цикл события от UI до PLC.
- **`03-multitenancy.md`** — мультиарендность (если применимо).
- **`04-security.md`** — аутентификация, авторизация, базовые защиты.
- **`05-reliability.md`** — ретраи, идемпотентность, health checks.
- **`DIAGRAMS.md`** — 2–3 Mermaid-диаграммы (компоненты, multitenancy, sequence).
- **`KEY_DECISIONS.md`** — ключевые решения/компромиссы (5–7 пунктов).
- **`DEMO_WALKTHROUGH.md`** — обзор функциональности системы.
- **`REDACTION.md`** — что и почему скрыто в showcase.
- **`adr/`** — архитектурные решения (ADR): 0001-use-blazor-server, 0002-centralize-plc-logic, 0003-default-sqlite-storage, 0004-hybrid-ocr-pipeline.

### Навигаторы кода
- **`backend/WHERE_TO_LOOK.md`** — 6–8 файлов backend с пояснением "зачем смотреть".
- **`frontend/WHERE_TO_LOOK.md`** — 6–8 файлов frontend с пояснением.

### Примеры окружения
- **`backend/ENV_EXAMPLE.md`** — только placeholders (`CHANGE_ME`).
- **`frontend/README.md`** — описание frontend и примеры env.
- **`appsettings.example.json`** — пример конфигурации с плейсхолдерами.
- **`docker-compose.example.yml`** — демо-БД MySQL с паролями `CHANGE_ME`.

### SQL
- **`sql/schema_only/core_tables.sql`** — только CREATE TABLE, без данных.
- **`sql/seed_demo.sql`** — синтетический seed (минимум для оживления демо).

## Ограничения

- **Без прод-доменов, токенов, IP и реальных данных**: все чувствительные значения заменены на плейсхолдеры `CHANGE_ME`.
- **Конфиги**: `appsettings.json` содержит демо-значения; реальные секреты должны быть в `.env` (игнорируется git).
- **Описана только безопасная демо-топология**: прод-инфраструктура, фаерволы, VPN, сетевые ACL не документируются.

## Локальный демо-прогон

### Предварительные требования
- .NET 8 SDK
- Docker и Docker Compose (опционально, для демо-MySQL)

### Быстрый старт

1. **Применить миграции БД**:
   ```bash
   dotnet ef database update
   ```

2. **Запустить приложение**:
   ```bash
   dotnet run
   ```

3. **Открыть в браузере**: http://localhost:5000

### Демо-сценарий

1. При первом запуске создаются тестовые пользователи (см. `Program.cs`)
2. Войти в систему с учётными данными из seed данных
3. Изучить структуру проекта через навигаторы (`backend/WHERE_TO_LOOK.md`, `frontend/WHERE_TO_LOOK.md`)
4. Просмотреть документацию архитектуры и ключевых решений
5. Запустить демонстрацию согласно [`DEMO_INSTRUCTIONS.md`](DEMO_INSTRUCTIONS.md)

## Структура проекта

```
├── Components/          # Blazor Server компоненты и страницы
├── Controllers/        # ASP.NET Core API контроллеры
├── Data/               # EF Core DbContext и фабрика
├── Models/             # Модели данных и DTOs
├── Plc/                # PLC/Modbus логика и драйверы
├── Services/           # Бизнес-логика сервисов
├── Migrations/         # EF Core миграции
├── Resources/          # Локализация (uk/en)
├── wwwroot/            # Статические файлы (CSS, JS, шаблоны печати)
├── docs/               # Документация showcase
├── backend/            # Backend навигаторы
├── frontend/           # Frontend навигаторы
├── sql/                # SQL схемы и seed
└── Program.cs           # Точка входа и конфигурация DI
```

## Дополнительные ресурсы

- [Архитектура](docs/01-architecture.md)
- [Поток данных](docs/02-data-flow.md)
- [Безопасность](docs/04-security.md)
- [Надёжность](docs/05-reliability.md)
- [Диаграммы](docs/DIAGRAMS.md)
- [Ключевые решения](docs/KEY_DECISIONS.md)
- [Политика редактирования](docs/REDACTION.md)

