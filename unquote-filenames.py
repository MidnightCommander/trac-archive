import logging
import urllib.parse
from pathlib import Path

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

for attachment in Path("attachments").glob("**/*"):
    if not attachment.is_file():
        continue

    name = attachment.name
    unquoted_name = urllib.parse.unquote(name)

    if unquoted_name != name:
        new_name = attachment.parent / unquoted_name
        logger.info(f"Renaming {attachment} -> {new_name}")
        attachment.rename(new_name)
