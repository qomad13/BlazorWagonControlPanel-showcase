# Frontend (Blazor Server UI)

Витрина работает в одном хосте вместе с backend (Blazor Server). Отдельных npm-зависимостей нет; статические файлы лежат в `wwwroot`.

ENV пример (если нужно разделять конфиг UI):
- `FRONTEND_BASE_URL=http://localhost:5000`
- `API_BASE_URL=http://localhost:5000`
- `DEFAULT_CULTURE=uk`
- `FEATURE_SHOW_DEMO_BUTTONS=true`

Запуск: `dotnet run` из корня, UI доступен на `FRONTEND_BASE_URL`.

