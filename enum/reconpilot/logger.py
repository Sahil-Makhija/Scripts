# logger.py - Logging setup
import logging
import sys

def setup_logger():
    logging.basicConfig(
        format="%(asctime)s [%(levelname)s] %(message)s",
        level=logging.DEBUG,
        handlers=[logging.StreamHandler(sys.stdout)]
    )
