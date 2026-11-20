-- Demo schema (SQLite-compatible syntax)
CREATE TABLE IF NOT EXISTS ButtonActions (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    ButtonName TEXT NOT NULL,
    UserLogin TEXT NOT NULL,
    ClickedAt TEXT NOT NULL,
    Description TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS IX_ButtonActions_ClickedAt ON ButtonActions(ClickedAt);
CREATE INDEX IF NOT EXISTS IX_ButtonActions_UserLogin ON ButtonActions(UserLogin);

CREATE TABLE IF NOT EXISTS ModbusSettings (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    IpAddress TEXT NOT NULL,
    Port INTEGER NOT NULL,
    SlaveId INTEGER NOT NULL,
    CreatedAt TEXT NOT NULL,
    UpdatedAt TEXT NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS IX_ModbusSettings_Id ON ModbusSettings(Id);

CREATE TABLE IF NOT EXISTS ProcessedWagons (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    TrackId INTEGER NOT NULL,
    WagonNumber TEXT NOT NULL,
    ArrivedAt TEXT NOT NULL,
    DepartedAt TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS Settings (
    Key TEXT PRIMARY KEY,
    Value TEXT NOT NULL,
    Description TEXT
);

CREATE TABLE IF NOT EXISTS Users (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Login TEXT NOT NULL,
    Password TEXT NOT NULL,
    UserType TEXT NOT NULL,
    DisplayName TEXT NOT NULL,
    CreatedAt TEXT NOT NULL,
    UpdatedAt TEXT NOT NULL,
    FullName TEXT NOT NULL,
    Role TEXT NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS IX_Users_Login ON Users(Login);

CREATE TABLE IF NOT EXISTS CameraSettings (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    CameraNumber INTEGER NOT NULL,
    ConnectionString TEXT NOT NULL,
    Description TEXT,
    IsActive INTEGER NOT NULL,
    CreatedAt TEXT NOT NULL,
    UpdatedAt TEXT NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS IX_CameraSettings_CameraNumber ON CameraSettings(CameraNumber);

CREATE TABLE IF NOT EXISTS ContactInfo (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    TechnicianName TEXT NOT NULL,
    TechnicianPhone TEXT NOT NULL,
    TechnicianEmail TEXT NOT NULL,
    AdministratorName TEXT NOT NULL,
    AdministratorPhone TEXT NOT NULL,
    AdministratorEmail TEXT NOT NULL,
    SupportName TEXT NOT NULL,
    SupportPhone TEXT NOT NULL,
    SupportEmail TEXT NOT NULL,
    LastUpdated TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS PrinterLogs (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Timestamp TEXT NOT NULL,
    User TEXT NOT NULL,
    TrackId INTEGER NOT NULL,
    WagonId TEXT NOT NULL,
    WagonNumber TEXT NOT NULL,
    Action TEXT NOT NULL,
    Result TEXT NOT NULL,
    Comment TEXT
);

