# InterAI Hub

A multi-agent AI orchestration desktop app for Windows. The Hub acts as
"chat for multiple agents" — you compose a single message, and a
configured roster of LLMs (Claude, GPT, Gemini, Mistral, and others)
take turns responding, with their full conversation history maintained
across rounds.

> **First time here?** Read the **[Quick Start guide](docs/QuickStart.md)** — a 15-minute walkthrough from zero to your first multi-agent conversation.

## Install

1. Download **`setup.exe`** from this repo (or the [Releases](https://github.com/dgplugge/interai-hub-clickonce/releases) tab when one is published).
2. Run it. ClickOnce installs the Hub to your user profile and adds a Start menu entry.
3. **Don't launch yet** — first run the setup script (next section) so the Hub has API keys to talk to providers.

Requires **.NET Framework 4.8** (Windows 10 and 11 ship with it; the installer prompts otherwise).

## Connect to AI providers

Before launching the Hub, run the setup script. It walks you through getting an API key from each of four providers (Anthropic, OpenAI, Google, Mistral) and writes a working config to `%APPDATA%\AgentHub\agent-hub-config.json`. You can skip any provider; even one is enough.

Open PowerShell and run:

```powershell
iwr https://raw.githubusercontent.com/dgplugge/interai-hub-clickonce/main/Setup-InterAI-Hub.ps1 -OutFile $env:TEMP\Setup-InterAI-Hub.ps1
powershell -ExecutionPolicy Bypass -File $env:TEMP\Setup-InterAI-Hub.ps1
```

Detailed signup steps for each provider — what to click, what to copy, free-tier guidance — are in **[docs/ApiKeys.md](docs/ApiKeys.md)**.

When the script finishes, launch **InterAI Hub** from the Start menu. The first launch asks you to pick a Journal folder (any folder works), then you're ready to dispatch your first round.

## Trial and licensing

The Hub runs on a **30-day free trial** — full speed, all features. After 30 days it enters **degraded mode** (a 10-second delay before each LLM dispatch) until you register.

To register: click **Register…** in the bottom-left controls panel, paste your license key into the dialog, click **Activate**. Keys are issued by the maintainer; contact via the Issues tab below to enquire.

## Reporting bugs

Click **Report a Bug…** in the Hub's controls panel. The button opens a pre-filled GitHub issue in your browser with your app version, OS, and the path to the local log file (`%APPDATA%\InterAI-Hub\Logs\`). Add what you were doing, attach the log if relevant, and submit.

Alternatively, file an issue directly on the [Issues tab](https://github.com/dgplugge/interai-hub-clickonce/issues).

## What's in this repo

This is the **public ClickOnce deployment** repo — installer plus manifest plus binaries plus end-user docs. The application source code is private.

- `setup.exe` — the ClickOnce bootstrapper.
- `AAAAgentHub.application` — the ClickOnce manifest.
- `Application Files/AAAAgentHub_<version>/` — the actual binaries for that version.
- `Setup-InterAI-Hub.ps1` — interactive PowerShell script that collects API keys and writes the Hub's config.
- `docs/QuickStart.md` — 15-minute walkthrough from zero to first dispatch.
- `docs/ApiKeys.md` — provider-by-provider signup steps for Anthropic, OpenAI, Google, and Mistral.
