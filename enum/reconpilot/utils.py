# utils.py - Utility functions
import subprocess
import logging
import re

def ping_target(target):
    """Ping the target to check if it's reachable."""
    logging.info(f"[+] Pinging target: {target}")
    try:
        subprocess.run(["ping", "-c", "3", target], capture_output=True, text=True, check=True)
        logging.info("[✓] Target is reachable.")
        return True
    except subprocess.CalledProcessError:
        logging.error("[X] Target is unreachable. Exiting.")
        return False

def is_ip(target):
    """Determine if the target is an IP address."""
    logging.info("[+] Checking if target is an IP or domain...")
    ip_pattern = re.compile(r"^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$")
    if ip_pattern.match(target):
        logging.info("[✓] Target is an IP address.")
        return True
    else:
        logging.info("[✓] Target is a domain.")
        return False
