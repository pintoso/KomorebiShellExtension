from argparse import ArgumentParser, Namespace
from configparser import ConfigParser
from json import dump, load
from pathlib import Path
from subprocess import CREATE_NO_WINDOW, run
from time import sleep


def parse_config() -> str:
    """
    Parse settings.ini
    """
    config = ConfigParser()
    config.read(Path(__file__).parent / "settings.ini")
    return config["hotkeys"]["handler"].replace('"', "")


KOMOREBI = run(
    ["powershell", "-Command", "komorebic config"],
    creationflags=CREATE_NO_WINDOW,
    capture_output=True,
    text=True,
).stdout.strip()
HOTKEY_HANDLER = "--" + parse_config()

STOP = ["powershell", "-Command", "komorebic stop", HOTKEY_HANDLER]
START = ["powershell", "-Command", "komorebic start", HOTKEY_HANDLER]


def parse_args() -> Namespace:
    """
    Parse command line arguments
    """
    parser = ArgumentParser()
    parser.add_argument("id", type=str, help="Application ID (exe, title or class)")
    parser.add_argument(
        "kind",
        type=str,
        choices=["exe", "title", "class"],
        help="Kind of rule to manage by",
    )
    parser.add_argument(
        "-m",
        "--manage",
        action="store_true",
        help="Add manage rule for provided application by Komorebic",
    )
    parser.add_argument(
        "-i",
        "--ignore",
        action="store_true",
        help="Add ignore rule for provided application by Komorebic",
    )
    return parser.parse_args()


def manage_rule(id: str, kind: str) -> int:
    """
    Add manage rule to komorebi.json
    """
    # Open komorebi.json and parse it
    with open(KOMOREBI, "r", encoding="utf-8") as f:
        komorebi = load(f)

    # Get ignore rules
    ignore_rules = komorebi.get("ignore_rules", [])

    # Get manage rules
    manage_rules = komorebi.get("manage_rules", [])

    # Check if ignore rule for id exists, remove if found
    if ignore_rules:
        for i, rule in enumerate(ignore_rules):
            if rule["id"] == id:
                del ignore_rules[i]

    # Check if manage rule for id exists, abort if found
    if manage_rules:
        for rule in manage_rules:
            if rule["id"] == id:
                return 1

    # Add manage rule
    manage_rules.append({"kind": kind.title(), "matching_strategy": "Equals", "id": id})

    # Update rules section
    komorebi["manage_rules"] = manage_rules
    komorebi["ignore_rules"] = ignore_rules

    # Write to komorebi.json
    with open(KOMOREBI, "w", encoding="utf-8") as f:
        dump(komorebi, f)

    return 0


def ignore_rule(id: str, kind: str) -> int:
    """
    Add manage rule to komorebi.json
    """
    # Open komorebi.json and parse it
    with open(KOMOREBI, "r", encoding="utf-8") as f:
        komorebi = load(f)

    # Get ignore rules
    ignore_rules = komorebi.get("ignore_rules", [])

    # Get manage rules
    manage_rules = komorebi.get("manage_rules", [])

    # Check if manage rule for id exists, remove if found
    if manage_rules:
        for i, rule in enumerate(manage_rules):
            if rule["id"] == id:
                del manage_rules[i]

    # Check if ignore rule for id exists, abort if found
    if ignore_rules:
        for rule in ignore_rules:
            if rule["id"] == id:
                return 1

    # Add ignore rule
    ignore_rules.append({"kind": kind.title(), "matching_strategy": "Equals", "id": id})

    # Update rules section
    komorebi["manage_rules"] = manage_rules
    komorebi["ignore_rules"] = ignore_rules

    # Write to komorebi.json
    with open(KOMOREBI, "w", encoding="utf-8") as f:
        dump(komorebi, f)

    return 0


def main():
    # Parse command line arguments
    args = parse_args()

    # Get id
    id = Path(args.id).name

    result = None

    # Manage
    if args.manage:
        result = manage_rule(id, args.kind)

    # Ignore
    if args.ignore:
        result = ignore_rule(id, args.kind)

    # If changes were made, restart
    if result == 0:
        run(STOP, creationflags=CREATE_NO_WINDOW)
        sleep(0.2)
        run(START, creationflags=CREATE_NO_WINDOW)


if __name__ == "__main__":
    main()
