#!/bin/bash

# Print title
echo -e "\n██╗  ██╗████████╗████████╗██████╗     ██████╗ ██████╗  ██████╗ ██╗  ██╗██╗   ██╗    ██████╗  ██████╗ ██████╗ ████████╗    ███████╗ ██████╗ █████╗ ███╗   ██╗███╗   ██╗███████╗██████╗ 
██║  ██║╚══██╔══╝╚══██╔══╝██╔══██╗    ██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝╚██╗ ██╔╝    ██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝    ██╔════╝██╔════╝██╔══██╗████╗  ██║████╗  ██║██╔════╝██╔══██╗
███████║   ██║      ██║   ██████╔╝    ██████╔╝██████╔╝██║   ██║ ╚███╔╝  ╚████╔╝     ██████╔╝██║   ██║██████╔╝   ██║       ███████╗██║     ███████║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝
██╔══██║   ██║      ██║   ██╔═══╝     ██╔═══╝ ██╔══██╗██║   ██║ ██╔██╗   ╚██╔╝      ██╔═══╝ ██║   ██║██╔══██╗   ██║       ╚════██║██║     ██╔══██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗
██║  ██║   ██║      ██║   ██║         ██║     ██║  ██║╚██████╔╝██╔╝ ██╗   ██║       ██║     ╚██████╔╝██║  ██║   ██║       ███████║╚██████╗██║  ██║██║ ╚████║██║ ╚████║███████╗██║  ██║
╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝         ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝       ╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝       ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝\n"

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"

# Prompt user to enter proxy
echo -e "${YELLOW}Enter the proxy (example: http://user:password@ip:port - http://user:password@domain:port - http://ip:port - http://domain:port)${ENDCOLOR}"
read -e -p "Proxy: " proxy

# Prompt user to enter target
echo -e "\n${YELLOW}Enter the target (example: http://ip - http://domain - ip - domain):${ENDCOLOR}"
read -e -p "Target: " target

# Prompt user to enter ports
echo -e "\n${YELLOW}Enter up to which port you want to scan (example: 65535):${ENDCOLOR}"
read -e -p "Ports: " ports

# File to store open ports
output_file="openPortsHttpProxy.txt"

# Clear the file if it already exists
rm "$output_file" &>/dev/null

# Scan ports from 1 to specified port and store open ports in a file
for ((i=1; i<=ports; i++)); do
  status_code=$(curl -o /dev/null -s -w "%{http_code}" --proxy "$proxy" "$target:$i")
  if [ "$status_code" -eq 200 ]; then
    echo -e "\t${GREEN}[*] Port $i - OPEN${ENDCOLOR}"
    echo "Port $i - OPEN" >> "$output_file"
  fi
done
echo -e "\n${GREEN}[+] Scan completed, open ports have been saved to $output_file${ENDCOLOR}"

# Copy open ports to clipboard
cat "$output_file" | awk '/Port/ {print $2}' | tr '\n' ',' | sed 's/,$//;s/,*$//g' | xclip -sel clip
echo -e "${GREEN}[+] Ports have been copied to clipboard${ENDCOLOR}"
echo -e "${GREEN}[+] Los puertos han sido copiados en la clipboard${ENDCOLOR}"
