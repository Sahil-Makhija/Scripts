#!/bin/bash

# Define the folder structure
mkdir -p Information-Gathering/{nmap,dirbust,vhosts}
mkdir -p Vulnerability-Scanning
mkdir -p Exploitation/{exploits,http-reqres}
mkdir -p Post-Exploitation/{shell,privesc}
# mkdir -p results/{nmap-results,dirbust-results,vulnerability-scanning-results}
mkdir -p data-exfil

# Print success message
echo "Folder structure created successfully!"
