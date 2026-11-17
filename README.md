# REVERSEX-Cybersecurity-Automation-Tool
" A Bash-based cybersecurity automation toolkit for authorized reverse connection testing, TCP listener management, and Metasploit integration in controlled lab environments."
# 🛡️ REVERSEX

An interactive, color-coded Bash script designed for **Kali Linux** to help security students and practitioners manage network listeners, generate multi-language reverse shell payloads, and automate Metasploit Framework (`msfvenom` & `msfconsole`) configurations in controlled lab environments.

---

## ✨ Features

- **Interactive TCP Listener:** Quickly spin up a netcat listener bound to custom local IP (`LHOST`) and port (`LPORT`) configurations.
- **Multi-Language Payload Generator:** Instantly generate ready-to-use reverse shell one-liners for:
  - Bash (TCP)
  - Python 3
  - PHP
  - PowerShell
  - Netcat
- **`msfvenom` Integration:** Build standalone executable and script payloads (`.exe`, `.elf`, `.php`, `.apk`) tailored to your lab target.
- **Automated Metasploit Handlers:** Automatically generates a companion resource script (`handler.rc`) to spin up `msfconsole` with pre-configured multi/handler parameters.
- **Session Logging:** Logs listener start times and generated payloads automatically to `connection_logs.txt`.
- **Input Validation:** Built-in IP address and port range validation (1024–65535).

---

## 🚀 Prerequisites

Ensure the following tools are installed on your Kali Linux environment:
- `netcat` (`nc`)
- `msfvenom` & `msfconsole` (Metasploit Framework)

---

## ⚙️ Usage

1. Clone or download the script to your Kali Linux machine.
2. Grant execution permissions to the script:
   ```bash
   chmod +x rev_shell.sh
3. Run the script: 
   ./rev_shell.sh
