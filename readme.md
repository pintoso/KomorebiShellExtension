# KomorebiShellExtension

KomorebiShellExtension is a Python-based tool that extends the functionality of the [Komorebi](https://github.com/LGUG2Z/komorebi) tiling window manager by integrating rule management directly into the Windows context menu. This extension allows users to easily add or remove "Manage" and "Ignore" rules for applications without manually editing the `komorebi.json` configuration file.

## Features

- **Context Menu Integration**: Adds "Manage with Komorebi" and "Don't manage with Komorebi" options to the Windows context menu for files.
- **Dynamic Rule Management**: Updates Komorebi's configuration file (`komorebi.json`) to include or exclude specified applications.
- **Automatic Restart**: Restarts Komorebi to apply changes after rules are updated.
- **Customizable Hotkey Handler**: Reads settings from `settings.ini` to configure Komorebi's hotkey handler.

## Requirements

- Python 3.x
- Komorebi installed and configured
- Windows operating system

## Installation

### Step 1: Clone the Repository
```bash
git clone https://github.com/Zira3l137/KomorebiShellExtension.git
cd KomorebiShellExtension
```

### Step 2: Configure `settings.ini`
Create a `settings.ini` file in the same directory as `KomorebiRuleManager.py` with the following structure:

```ini
[settings]
hotkey_handler = "your-hotkey-handler"
use_bar = true
```
Replace `your-hotkey-handler` with your Komorebi hotkey handler. It's usually either `ahk` or `whkd`.
Decide whether or not to use the Komorebi bar by setting `use_bar` to `true` or `false`.
**Note:** This can be changed anytime.

### Step 3: Run the PowerShell Installation Script
Run the included PowerShell script to set up the context menu entries:

```powershell
.\KomorebiShell.ps1
```
This script:
- Locates `KomorebiRuleManager.py` and Python.
- Adds registry entries to integrate context menu options.

## Usage

1. **Right-Click a File**: Navigate to any file in File Explorer, right-click, and choose:
   - "Manage this file with Komorebi"
   - "Don't manage this file with Komorebi"

2. **Command Line Options**: You can also run the script manually:
   ```bash
   python KomorebiRuleManager.py <id> <kind> [--manage | --ignore]
   ```
   - `<id>`: Application ID (e.g., exe name, window title, or class).
   - `<kind>`: Type of ID (`exe`, `title`, or `class`).
   - `--manage`: Add a manage rule.
   - `--ignore`: Add an ignore rule.

## How It Works

1. The script parses `komorebi.json` to update `manage_rules` or `ignore_rules`.
2. It removes conflicting rules to ensure consistency.
3. Komorebi is stopped and restarted to apply the changes.

## Troubleshooting

- **Python Not Found**: Ensure Python is installed and available in your system's PATH.
- **Komorebi Configuration File Not Found**: Verify that `komorebic config` returns the correct path to `komorebi.json`.
- **Permissions**: Run the PowerShell script with administrator privileges if registry modifications fail.

## Contributing

Feel free to submit issues or pull requests to improve this project. Contributions are welcome!

## Acknowledgments

- [Komorebi](https://github.com/LGUG2Z/komorebi) for the tiling window manager.
- The Python and PowerShell communities for their tools and support.

