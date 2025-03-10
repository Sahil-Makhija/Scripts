import subprocess
import logging

wordlists={
    "default":"/usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-5000.txt",
    "extensive":"/usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-11000.txt"
}

def brute_subdomains(target):
    """Gobuster to brute-force subdomains."""
    logging.info(f"[+] Starting subdomain brute-force on: {target}")
    logging.info(f"[+] Using wordlist: {wordlists['default']}")
    
    cmd = [
        "gobuster", "vhost", "-u", f"http://{target}/", "-w", wordlists['default'], "--append-domain"
    ]
    
    try:
        process = subprocess.run(cmd, capture_output=True, text=True, check=True)
        logging.info("[✓] Gobuster execution completed successfully.")
        logging.info("[+] Output:")
        logging.info(process.stdout)
    except subprocess.CalledProcessError as e:
        logging.error("[X] Gobuster encountered an error.")
        logging.error(e.stderr)
