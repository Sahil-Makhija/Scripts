#!/bin/bash

# Function to find unique ports in the second list that are not in the first list.
unique_ports() {
    local list1=($(echo "$1" | tr ',' ' '))
    local list2=($(echo "$2" | tr ',' ' '))
    local unique=()

    # Iterate through the second list and check if each port is absent in the first list.
    for num in "${list2[@]}"; do
        if [[ ! " ${list1[@]} " =~ " $num " ]]; then
            unique+=($num)
        fi
    done

    echo "${unique[@]}" | tr ' ' ','
}

# Function to check if the target machine is reachable via ping.
function ping_machine {
    if ping -c 1 -W 1 "$ip" &>/dev/null; then  # Set a timeout of 1 second for faster failure detection.
        reachable=true
        echo -e "[+] Target machine is reachable."
    else
        reachable=false
    fi
}

function choose_scan_type {
    echo -e "[*] Choose a Scan Type :\n\t[1] Init Scan (Top 1000 ports)\n\t[2] TCP Scan (Deep Scan for all TCP ports) [Default]\n\t[3] UDP Scan (Deep Scan for UDP ports)\n\t[4] Both TCP + UDP Scan"
    read -p "Select : " scan_type
}

# Function to prepare the directory for storing Nmap scan results.
function prepare_scans {
    [[ ! -d nmap ]] && mkdir nmap  # Create 'nmap' directory if it doesn't exist.
}

# Function to perform an initial Nmap scan with default scripts and version detection.
function init_scan {
    echo "Performing initial scan..."
    nmap -sC -sV -Pn -n -vv --open "$ip" -oN nmap/init
    init_ports=$(grep '^[0-9]' nmap/init | cut -d '/' -f1 | tr '\n' ',' | sed 's/,$//')
}

# Function to perform a TCP scan and identify new open ports.
function tcp_scan {
    echo "Scanning for open TCP ports..."
    local tcp_ports=$(nmap -sT -p- --min-rate=1000 -Pn -n "$ip" -oN nmap/tcp_search | \
                      grep '^[0-9]' | cut -d '/' -f1 | tr '\n' ',' | sed 's/,$//')
    local new_ports=$(unique_ports "$init_ports" "$tcp_ports")

    if [[ -n "$new_ports" ]]; then
        echo "New TCP port(s) identified: $new_ports"
        echo "Performing a deep scan on newly discovered ports..."
        nmap -sC -sV -p"$new_ports" "$ip" -Pn -n -vv -oN nmap/tcp_deep
    else
        echo "No new TCP ports found."
    fi
}

# Function to perform a UDP scan and identify new open ports.
function udp_scan {
    echo "Scanning for open UDP ports..."
    local udp_ports=$(nmap -sU -p- --min-rate=1000 -Pn -n "$ip" -oN nmap/udp_search | \
                      grep '^[0-9]' | cut -d '/' -f1 | tr '\n' ',' | sed 's/,$//')
    local new_ports=$(unique_ports "$init_ports" "$udp_ports")

    if [[ -n "$new_ports" ]]; then
        echo "New UDP port(s) identified: $new_ports"
        echo "Performing a deep scan on newly discovered ports..."
        nmap -sC -sV -p"$new_ports" "$ip" -Pn -n -vv -oN nmap/udp_deep
    else
        echo "No new UDP ports found."
    fi
}

if [[ $# -eq 0 ]]
then
    # Prompt the user for the target machine's IP address.
    read -p "Enter Machine IP: " ip
else
    ip=$1
fi

reachable=false
scan_type=2 # Default scan type
ping_machine  # Check if the target is reachable.

if [[ "$reachable" == true ]]; then
    prepare_scans  # Ensure the results directory is ready.
    if [[ $# -eq 0 ]]
    then
        choose_scan_type
    else
        if [[ $2 ]];then
        scan_type=$2
        fi
    fi
    case $scan_type in 
        "1") init_scan ;; 
        "2") tcp_scan ;;
        "3") udp_scan ;;
        "4") tcp_scan ; udp_scan ;;
        "*") echo -e "[-] Invalid scan type selected"; exit 1 ;; 
    esac
else
    echo "Machine not reachable! Please check your VPN or network settings."
    exit 1
fi

# Cleanup: Unset variables to free memory.
unset ip
unset scan_type
unset init_ports
unset reachable
exit 0
