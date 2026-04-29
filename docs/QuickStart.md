# Quick Start — InterAI Hub

This guide walks you from "I just heard about this app" to "I'm having a multi-agent conversation" in about 15–25 minutes, the first time.

You will:
1. Install the Hub.
2. Get API keys from one or more AI providers.
3. Run a small setup script that writes your keys into the Hub's config.
4. Launch the Hub and try a first dispatch.

You don't need any programming experience. You do need a working Windows machine and a credit card or payment method for the providers that require one (some don't — see [API Keys](ApiKeys.md)).

---

## 1. Install the Hub

1. Go to the releases page: <https://github.com/dgplugge/interai-hub-clickonce>
2. Download **`setup.exe`** (it's at the top of the file list).
3. Double-click `setup.exe` to run it.
4. Windows may show a "Windows protected your PC" warning — click **More info**, then **Run anyway**. (This is normal for software not yet seen by Microsoft's filter.)
5. The installer runs and adds **InterAI Hub** to your Start menu.

If the installer says **".NET Framework 4.8 is required"**, accept the prompt to install it. Windows 10 and 11 generally already have it.

**Don't launch the Hub yet** — we'll set up API keys first so the Hub has something to talk to on first launch.

---

## 2. Get API keys

The Hub talks to four AI providers: **Anthropic** (Claude), **OpenAI** (GPT-4o, o3-mini), **Google** (Gemini), and **Mistral**. Each has its own signup and its own API key. You don't need all four — even one is enough to use the Hub. More providers means more variety in the round-table conversations.

For step-by-step instructions for each provider — including which buttons to click and what to copy — see **[API Keys](ApiKeys.md)**. Read that page now, then come back.

A few practical notes:
- **Save the keys somewhere temporarily** — a Notepad window, a password manager — until step 3. Most providers show the key value only once.
- **Costs are usually pennies per session** with default settings. If a provider asks for a payment method, that's normal; you'll be charged based on use, not in advance, and the Hub itself doesn't add any cost.
- Anthropic and Google both have free tiers — start with those if you want to evaluate without spending money.

---

## 3. Run the setup script

1. Right-click **Start** → **Windows PowerShell** (or **Terminal**).
2. Download the script (or open it directly):

   ```powershell
   iwr https://raw.githubusercontent.com/dgplugge/interai-hub-clickonce/main/Setup-InterAI-Hub.ps1 -OutFile $env:TEMP\Setup-InterAI-Hub.ps1
   ```

3. Run it:

   ```powershell
   powershell -ExecutionPolicy Bypass -File $env:TEMP\Setup-InterAI-Hub.ps1
   ```

   (The `-ExecutionPolicy Bypass` is needed because Windows blocks unsigned scripts by default. The `Bypass` is scoped to this single run only — your system policy is unchanged.)

4. The script walks you through the four providers in order. For each one:
   - It offers to open the provider's signup page in your browser.
   - You sign up / sign in / create a key on that page.
   - You paste the key back into the script window and press Enter.
   - To skip a provider, just press Enter without pasting.

5. When all four steps are done, the script writes the config to:

   ```text
   %APPDATA%\AgentHub\agent-hub-config.json
   ```

   (That's `C:\Users\<your-username>\AppData\Roaming\AgentHub\agent-hub-config.json` if you ever need to edit it by hand.)

6. The script prints a summary of which agents are configured, then exits.

**Re-running the script** is safe — it asks before overwriting an existing config and saves a timestamped backup of the previous one.

---

## 4. Launch the Hub

1. Open **Start** → **InterAI Hub**.
2. **First-launch prompt: Journal folder.** The Hub asks where to store its conversation log. Pick or create a folder anywhere — `Documents\InterAI-Journals` is a fine default. The Hub will create it if it doesn't exist.
3. The Hub window opens. Top-left lists the agents you configured. Bottom-left shows controls. The big middle area is the conversation transcript.
4. Look at the bottom-left **Activity log**: it should say something like `[license] Trial — 30 days remaining`. That's your free trial — full speed for 30 days, then the Hub goes into degraded mode (10-second delay per agent) until you register a license.
5. Type a message in the **Message** box at the bottom (e.g., "What's the most useful thing AI can do for an architecture office?").
6. Click **Send** for a single agent, or **Dispatch Round** in the controls panel to ask all enabled agents in turn.

Each agent answers based on its system prompt and provider. Watch the transcript — different agents have different voices.

---

## 5. What now?

- **Try the three turn modes.** The dropdown in the controls panel is **Round Robin** by default. Try **Hourglass** (forward + backward pass through agents — useful when you want consensus) and **Parallel** (all agents at once — faster but no cross-talk).
- **Register a license** if you've purchased one. Click **Register…** in the controls panel and paste the key. Otherwise the trial runs for 30 days.
- **Pick a project.** The **Project** dropdown at the bottom of the controls panel scopes the conversation context. Switching projects clears the transcript but preserves your in-progress message.
- **Report a bug.** Click **Report a Bug…** — it opens a pre-filled GitHub issue with your version, OS, and log location. Add what you were doing and submit.

For detailed reference on what each control does and the AICP message format, see the [InterAI Hub source repo](https://github.com/dgplugge/interai-hub) (private; ask the maintainer if you need access).
