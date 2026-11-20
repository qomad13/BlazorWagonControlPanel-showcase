# Key decisions and trade-offs

## 1. Blazor Server instead of a SPA

**Decision**: use Blazor Server for the UI instead of a separate SPA (React/Vue/Angular).

**Rationale**:
- Real-time UI is faster to build on the built-in SignalR
- Smaller front-end footprint (no separate npm build)
- One C# codebase for backend and frontend
- Simpler integration with the existing ASP.NET Core code

**Trade-offs**:
- Depends on a stable connection (state is lost when the circuit drops)
- More server load (UI is processed on the server)
- Scaling needs sticky sessions or a SignalR backplane

**Alternatives**: Blazor WebAssembly (larger download, works offline), React SPA (more infrastructure)

---

## 2. SQLite by default

**Decision**: use SQLite as the default store instead of PostgreSQL/MySQL.

**Rationale**:
- A simple local demo database (one file, no separate server)
- Quick start for development and demonstration
- Fine for small deployments

**Trade-offs**:
- Limited scalability (single writer, size limits)
- Fewer advanced features (triggers and stored procedures are limited)
- Scaling up means migrating to PostgreSQL/MySQL

**Alternatives**: PostgreSQL (harder to set up for a demo), MySQL (needs Docker), InMemory (does not keep state)

---

## 3. A single `PlcLogicEngine`

**Decision**: keep all PLC business logic in one file, `Plc/PlcLogicEngine.cs`.

**Rationale**:
- One place to change for PLC programmers
- Easier review and audit of the logic
- No duplicated logic in different places

**Trade-offs**:
- The file can grow and need refactoring
- Requires discipline from developers (do not scatter logic across other files)
- Can become a bottleneck in parallel development

**Alternatives**: spread the logic over services (harder to find), use external scripts (harder to integrate)

---

## 4. JWT with a cookie fallback

**Decision**: use JWT tokens for the API, with the option of keeping the token in a cookie for Blazor.

**Rationale**:
- Convenient UX in Blazor (the token is sent automatically after a page reload)
- Standard approach for a REST API
- Supports roles and authorisation policies

**Trade-offs**:
- Cookie security must be configured (HttpOnly, Secure, SameSite)
- A real deployment needs HTTPS to protect the tokens
- Cookies can be exposed to XSS if configured badly

**Alternatives**: JWT in headers only (inconvenient for Blazor), sessions (not suited to an API)

---

## 5. Modbus as the default driver

**Decision**: use Modbus TCP as the main protocol to the PLC instead of OPC UA.

**Rationale**:
- Minimal dependencies (the NModbus library)
- Simple to implement and debug
- Widespread in industry
- Less overhead than OPC UA

**Trade-offs**:
- Less data typing (everything is registers)
- Register map is maintained by hand (the mapping must be documented)
- Fewer capabilities than OPC UA (metadata, subscriptions)

**Alternatives**: OPC UA (more capable but more complex), proprietary protocols (vendor lock-in)

---

## 6. Print templates in wwwroot

**Decision**: keep print templates (`*.prn`) in `wwwroot/prn-templates/`.

**Rationale**:
- Transparent and editable (change without recompiling)
- Versioned in Git
- Easy to update (replace a file)

**Trade-offs**:
- Template versions need control
- Templates should be validated on load
- Risk of mistakes with manual editing

**Alternatives**: store in the database (harder to edit), generate in code (less flexible)

---

## 7. Synthetic seed and redaction

**Decision**: use fully synthetic data for the demo and strip everything that comes from the real system.

**Rationale**:
- Safe to demonstrate without exposing customer data
- Meets confidentiality requirements
- Makes a public showcase possible

**Trade-offs**:
- Behaviour under real load is not shown
- Some edge cases may not appear in synthetic data
- Extra effort to build the demo data

**Alternatives**: anonymised real data (leak risk), no data at all (less illustrative)

---

## 8. Hybrid OCR pipeline (EasyOCR + PaddleOCR)

**Decision**: combine EasyOCR for locating regions with PaddleOCR for reading the digits.

**Rationale** (timings are the author's own measurements, not a benchmark):
- **EasyOCR** processes Full HD frames quickly and finds the regions that hold wagon numbers
- **PaddleOCR** reads digits well but is slow on full Full HD frames (about 3-5 s)
- Together: EasyOCR acts as the "spotter" and PaddleOCR reads only those regions
- Result: about 1 second per Full HD frame with good accuracy, even on damaged or dirty wagons

**Pipeline**:
1. Take a Full HD snapshot from the RTSP camera
2. EasyOCR analyses the image and finds regions that may hold wagon numbers
3. The cropped regions go to PaddleOCR to read the digits
4. Results are validated and returned to the system

**Trade-offs**:
- Two OCR engines (more dependencies and resources)
- Harder debugging (two processing stages)
- Replaced by the `CameraStubService` stub in this showcase to keep the demo simple

**Alternatives**:
- EasyOCR only (faster, but less accurate on damaged wagons)
- PaddleOCR only (more accurate, but slower on Full HD)
- Commercial OCR products (higher cost, vendor dependency)
