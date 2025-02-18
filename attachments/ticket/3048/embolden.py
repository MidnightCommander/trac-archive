import configparser
from pathlib import Path

BRIGHT_COLORS = (
    "gray",
    "brightred",
    "brightgreen",
    "yellow",
    "brightblue",
    "brightmagenta",
    "brightcyan",
    "white",
)

INPUT_FILE = "../misc/skins/default.ini"

config = configparser.ConfigParser()
config.read(INPUT_FILE)

for section in config.sections():
    bold_default = False
    for key in config[section].keys():
        fg_color, bg_color, style, *_ = config[section][key].split(";") + [None, None]
        if "bold" not in config[section][key]:
            if fg_color in BRIGHT_COLORS:
                config[section][key] += ";bold"
                if key == "_default_":
                    bold_default = True
            elif bold_default and style is None:
                config[section][key] += ";+"

with open(INPUT_FILE, "w") as f:
    config.write(f)

Path(INPUT_FILE).write_text(
    "\n".join([
        "    " + line.strip() if not line.startswith("[") and line.strip() else line
        for line in Path(INPUT_FILE).read_text().splitlines()
    ])
)
