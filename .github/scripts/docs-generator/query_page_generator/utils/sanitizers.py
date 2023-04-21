# Script created in Python 3.9.6 using only standard libraries
import re

def sanitize_filename(filename : str) -> str:
    # Remove any characters that are not allowed in filenames
    filename = re.sub(r'[^\w\s-]', '', filename)

    # Replace remaining special characters with an hyphen
    filename = re.sub(r'[\s]+', '-', filename)

    # Trim any leading or trailing whitespace
    filename = filename.strip()

    return filename.lower()