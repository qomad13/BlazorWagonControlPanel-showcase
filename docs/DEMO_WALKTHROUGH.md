# Feature overview

## Main UI pages

### Dashboard (`/`)
- Overview of the system state
- Track information (Track 1, Track 2)
- Quick access to the main functions

### Developer page (`/developer`)
- **Modbus settings**: PLC IP address and port, Slave ID, connection test
- **Camera settings**: 16 cameras (8 per track), RTSP URLs, snapshot capture
- **Database settings**: MySQL 1C connection parameters, connection test
- **Printer settings**: network printer IP address and port, test print

### Operations page (`/process`)
- **Track control**: track selection, operating mode (Waiting, Positioning, Sampling), bridge and wagon state
- **Commands**: start positioning, open/close hatches, start sampling, print labels
- **Operation log**: history of operator actions

### Printing (`/printer`)
- **Label printing**: choose track and wagon, preview the data, print one or several labels
- **Print log**: history of all print operations with results

## Key functions

### Automatic PLC logic
- `PlcLogicEngine` analyses the state and sends commands automatically
- Mode transitions (Waiting → Positioning → Sampling)
- Bit-edge handling for physical buttons on the PLC

### Integration with external systems
- **Modbus PLC**: polling state registers, sending commands
- **MySQL 1C**: reading wagon reference data through `MySqlOneCService`
- **RTSP cameras**: snapshots through OpenCvSharp
- **Network printer**: label printing over TCP/IP

### Logging and monitoring
- Structured logs with context (track number, wagon number, reason for a command)
- Operation logs in the database (`ButtonActions`, `PrinterLogs`)
- Monitoring of connections to external systems
