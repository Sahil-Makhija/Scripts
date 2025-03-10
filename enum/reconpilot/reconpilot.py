# reconpilot.py - Main script (entry point)
import sys
import logging
from logger import setup_logger
from utils import ping_target, is_ip
from subdomain_enum import brute_subdomains

def main():
    setup_logger()
    if len(sys.argv) < 2:
        logging.error('No target/IP provided.')
        print('''
Usage: python reconpilot.py <target IP/domain>
Example: pyhton reconpilot.py example.com # without url protocol
''')
        sys.exit(1)
    
    target = sys.argv[1]
    
    if not ping_target(target):
        sys.exit(1)
    
    target_is_ip = is_ip(target)
    
    # Example usage of subdomain brute-forcing
    if target_is_ip:
        return
    else:
        brute_subdomains(target)
    
if __name__ == "__main__":
    main()