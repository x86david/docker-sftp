## 📦 docker-sftp

A lightweight, secure SFTP server built with Docker and OpenSSH. This containerized setup exposes a shared folder via SFTP, isolates the user in a chroot jail, and allows easy customization through environment variables.

---

### 🚀 Features

- Based on `debian:stable-slim`
- SFTP-only access (no shell)
- Chrooted user environment
- Mounted volume for file sharing
- Configurable username and password via `.env`
- Accessible from any network interface (`0.0.0.0`)
- Docker Compose for easy orchestration

---

### 📁 Project Structure

```
docker-sftp/
├── data/                  # Shared folder exposed via SFTP
│   ├── images.jpeg
│   └── welcome.txt
├── Dockerfile             # SFTP server image
├── docker-compose.yml     # Service definition
├── .env                   # Username and password configuration
└── README.md              # You're reading it!
```

---

### ⚙️ Setup Instructions

#### 1. Clone the repo

```bash
git clone https://github.com/yourusername/docker-sftp.git
cd docker-sftp
```

#### 2. Configure credentials

Edit the `.env` file to set your desired SFTP username and password:

```env
SFTP_USER=david
SFTP_PASS=12345
```

> ✅ Docker Compose automatically loads the `.env` file from the project directory and injects these variables into the build and runtime configuration.

#### 3. Build and run the container

```bash
docker-compose build --no-cache
docker-compose up -d
```

---

### 🔌 Network Access

- **Internal port:** `22` (inside the container)
- **External port:** `2222` (on your host machine)

By default, the container binds to `0.0.0.0:2222`, which means:

> 🌐 The SFTP server is accessible from **any network interface** on your host — including LAN, VPN, or public IP (if allowed by firewall).

To restrict access to a specific interface (e.g. LAN IP):

```yaml
ports:
  - "192.168.1.100:2222:22"
```

---

### 🔓 Allow Port 2222 in Your Firewall

To make the SFTP server accessible from other devices on your LAN, you must allow incoming traffic on port `2222`. For example, using UFW:

```bash
sudo ufw allow 2222/tcp
```

Without this rule, the container may be running but unreachable from other devices.


If you want to allow incoming TCP traffic on port 2222 only from a specific IP address and only through a specific network interface, you can use this more restrictive UFW rule:

```bash
sudo ufw allow in on tun0 from 192.168.1.50 to any port 2222 proto tcp
```

---

### 🧪 Connect via SFTP

Use any SFTP client or command-line tool:

```bash
sftp -P 2222 david@<your-host-ip>
```

Replace `<your-host-ip>` with your LAN IP (e.g. `192.168.1.100`) or `localhost` if testing locally.

---

### 🧰 Useful Docker Commands

| Command | Description |
|--------|-------------|
| `docker-compose up -d` | Start container in background |
| `docker-compose down` | Stop and remove container |
| `docker-compose build --no-cache` | Rebuild image from scratch |
| `docker exec -it sftp-server bash` | Access container shell |
| `docker restart sftp-server` | Restart the container |
| `docker logs sftp-server` | View container logs |

---

### 🔒 Security Tips

- Use SSH key authentication for stronger security
- Restrict access using UFW or bind to VPN interfaces
- Monitor uploads/downloads with logging tools
- Avoid exposing port `2222` to the public internet unless necessary

---
