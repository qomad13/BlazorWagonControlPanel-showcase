-- Синтетический seed для демо
-- Пароли сгенерированы через BCrypt.Net.BCrypt.HashPassword()
INSERT INTO Users (Login, Password, UserType, DisplayName, CreatedAt, UpdatedAt, FullName, Role)
VALUES
  ('admin', '$2a$11$CHANGE_ME_HASHED_PASSWORD_FOR_ADMIN', 'internal', 'Admin Demo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Admin Demo', 'Administrator'),
  ('tech', '$2a$11$CHANGE_ME_HASHED_PASSWORD_FOR_TECH', 'internal', 'Tech Demo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Tech Demo', 'Technician');

INSERT INTO Settings (Key, Value, Description) VALUES
  ('app.culture', 'uk', 'Default culture'),
  ('plc.poll_interval_ms', '5000', 'Demo poll interval');

INSERT INTO ModbusSettings (IpAddress, Port, SlaveId, CreatedAt, UpdatedAt) VALUES
  ('127.0.0.1', 502, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO CameraSettings (CameraNumber, ConnectionString, Description, IsActive, CreatedAt, UpdatedAt) VALUES
  (1, 'rtsp://demo:demo@localhost:554/stream1', 'Demo camera', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO ContactInfo (TechnicianName, TechnicianPhone, TechnicianEmail, AdministratorName, AdministratorPhone, AdministratorEmail, SupportName, SupportPhone, SupportEmail, LastUpdated)
VALUES ('Demo Tech', '+000000000', 'tech@example.com', 'Demo Admin', '+000000001', 'admin@example.com', 'Demo Support', '+000000002', 'support@example.com', CURRENT_TIMESTAMP);

INSERT INTO PrinterLogs (Timestamp, User, TrackId, WagonId, WagonNumber, Action, Result, Comment) VALUES
  (CURRENT_TIMESTAMP, 'admin', 1, 'WGN-001', '12345678', 'print', 'ok', 'demo print');

