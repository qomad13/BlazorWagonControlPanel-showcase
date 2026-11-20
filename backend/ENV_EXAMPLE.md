# Backend ENV (example)

```
ASPNETCORE_ENVIRONMENT=Development
JWT__SECRETKEY=CHANGE_ME_MIN_32_CHARS
JWT__ISSUER=VagonLabDemo
ConnectionStrings__DefaultConnection=Data Source=vagonlab.db
ConnectionStrings__OneCDatabase=Server=mysql;Port=3306;Database=vagon_demo;Uid=demo_user;Pwd=CHANGE_ME;
Modbus__IpAddress=127.0.0.1
Modbus__Port=502
Modbus__SlaveId=1
Printer__Driver=demo
Camera__SnapshotDirectory=./snapshots
```

Do not keep real values in the repository; use a .env file (git-ignored).
