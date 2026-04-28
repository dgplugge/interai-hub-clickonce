# InterAI Hub

A multi-agent AI orchestration desktop app for Windows. The Hub acts as
"chat for multiple agents" — you compose a single message, and a
configured roster of LLMs (Claude, GPT, Gemini, Mistral, and others)
take turns responding, with their full conversation history maintained
across rounds.

## Install

1. Download **`setup.exe`** from this repo (or the [Releases](https://github.com/dgplugge/interai-hub-clickonce/releases) tab when one is published).
2. Run it. ClickOnce installs the Hub to your user profile and adds a Start menu entry.
3. Launch **InterAI Hub** from Start.

Requires **.NET Framework 4.8** (Windows 10 and 11 ship with it; the installer prompts otherwise).

## Trial and licensing

The Hub runs on a **30-day free trial** — full speed, all features. After 30 days it enters **degraded mode** (a 10-second delay before each LLM dispatch) until you register.

To register: click **Register…** in the bottom-left controls panel, paste your license key into the dialog, click **Activate**. Keys are issued by the maintainer; contact via the Issues tab below to enquire.

## Reporting bugs

Click **Report a Bug…** in the Hub's controls panel. The button opens a pre-filled GitHub issue in your browser with your app version, OS, and the path to the local log file (`%APPDATA%\InterAI-Hub\Logs\`). Add what you were doing, attach the log if relevant, and submit.

Alternatively, file an issue directly on the [Issues tab](https://github.com/dgplugge/interai-hub-clickonce/issues).

## What's in this repo

This is the **public ClickOnce deployment** repo — installer plus manifest plus binaries. The application source code is private.

- `setup.exe` — the ClickOnce bootstrapper.
- `AAAAgentHub.application` — the ClickOnce manifest.
- `Application Files/AAAAgentHub_<version>/` — the actual binaries for that version.
