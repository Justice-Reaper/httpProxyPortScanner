#!/bin/bash

echo -e "\n██╗  ██╗████████╗████████╗██████╗     ██████╗ ██████╗  ██████╗ ██╗  ██╗██╗   ██╗    ██████╗  ██████╗ ██████╗ ████████╗    ███████╗ ██████╗ █████╗ ███╗   ██╗███╗   ██╗███████╗██████╗ 
██║  ██║╚══██╔══╝╚══██╔══╝██╔══██╗    ██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝╚██╗ ██╔╝    ██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝    ██╔════╝██╔════╝██╔══██╗████╗  ██║████╗  ██║██╔════╝██╔══██╗
███████║   ██║      ██║   ██████╔╝    ██████╔╝██████╔╝██║   ██║ ╚███╔╝  ╚████╔╝     ██████╔╝██║   ██║██████╔╝   ██║       ███████╗██║     ███████║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝
██╔══██║   ██║      ██║   ██╔═══╝     ██╔═══╝ ██╔══██╗██║   ██║ ██╔██╗   ╚██╔╝      ██╔═══╝ ██║   ██║██╔══██╗   ██║       ╚════██║██║     ██╔══██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗
██║  ██║   ██║      ██║   ██║         ██║     ██║  ██║╚██████╔╝██╔╝ ██╗   ██║       ██║     ╚██████╔╝██║  ██║   ██║       ███████║╚██████╗██║  ██║██║ ╚████║██║ ╚████║███████╗██║  ██║
╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝         ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝       ╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝       ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝\n"

green="\e[32m"
yellow="\e[33m"
end_color="\e[0m"

echo -e "${yellow}Enter the proxy (example: http://user:password@ip:port - http://user:password@domain:port - http://ip:port - http://domain:port):${end_color}"
read -e -p "Proxy: " proxy

echo -e "\n${yellow}Enter the target (example: http://ip - http://domain - ip - domain):${end_color}"
read -e -p "Target: " target

echo -e "\n${yellow}Enter up to which port you want to scan (example: 65535):${end_color}"
read -e -p "Port: " port

output_file="openPortsHttpProxy.txt"

rm "$output_file" &>/dev/null

for ((i=1; i<=port; i++)); do
  status_code=$(curl -o /dev/null -s -w "%{http_code}" --proxy "$proxy" "$target:$i")
  if [ "$status_code" -eq 200 ]; then
    echo -e "\t${green}[*] Port $i - OPEN${end_color}"
    echo "Port $i - OPEN" >> "$output_file"
  fi
done
echo -e "\n${green}[+] Scan completed, open ports have been saved to $output_file${end_color}"

# Copy open ports to clipboard
cat "$output_file" | awk '/Port/ {print $2}' | tr '\n' ',' | sed 's/,$//;s/,*$//g' | xclip -sel clip
echo -e "${green}[+] Ports have been copied to clipboard${end_color}"
echo -e "${green}[+] Los puertos han sido copiados en la clipboard${end_color}"
