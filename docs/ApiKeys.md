# API Keys — How to get one from each provider

The InterAI Hub talks to several AI providers. Each one needs its own API key, usually a long random string that you paste into **Settings...** or the optional setup script. This page tells you exactly which buttons to click for common starter providers.

You can use **any subset** of the four. Even one provider is enough to make the Hub work; more providers means more variety in the round-table conversations.

| Provider | Free tier? | Payment required upfront? | Typical cost for moderate use |
|---|---|---|---|
| **Anthropic** (Claude) | Yes — small trial credit | No | Pennies per session |
| **OpenAI** / **OpenAI Responses** | Limited | **Yes** — must add a payment method | Pennies per session |
| **Google** (Gemini) | Yes — generous free tier | No | Often $0 for casual use |
| **Mistral** | Yes — small free quota | No (optional payment for higher limits) | Pennies per session |

**If you want to evaluate without spending anything,** start with Anthropic + Google. Both have meaningful free tiers and don't require a payment method.

---

## Anthropic (Claude)

**What it powers in the Hub:** Pharos, the Lead Coder agent.

1. Open <https://console.anthropic.com/settings/keys> in your browser.
2. **Sign up** (free) or **Sign in** with an existing account. You'll be asked to verify your email.
3. New accounts get a small trial credit — no credit card required to start.
4. On the API Keys page, click **Create Key** near the top right.
5. Give the key a name (e.g., `InterAI Hub`). Click **Create Key**.
6. A dialog shows the key value. **Copy it now** — Anthropic shows it only once. The key starts with `sk-ant-`.
7. Paste the key into the Hub's **Settings...** dialog or the setup script when it asks for the Anthropic key.

**If something goes wrong:** Anthropic's dashboard has a **Usage** tab where you can see if your key is being used. If your trial credit runs out, you'll need to add a payment method.

---

## OpenAI and OpenAI Responses

**What it powers in the Hub:** Lodestar (GPT-4o), Forge (o3-mini reasoning model), and SpinDrift (GPT-4o). One key, three agents.

1. Open <https://platform.openai.com/api-keys> in your browser.
2. **Sign up** (free) or **Sign in**. Email verification is required.
3. **Add a payment method.** OpenAI requires a card on file before letting you create API keys, even for low-volume use. Click your profile → **Billing** → **Add payment method**. A $5 starting balance is plenty for early use.
4. Back on the API Keys page, click **Create new secret key** at the top right.
5. Name the key (`InterAI Hub`). Choose **All** for permissions unless you have a reason to restrict.
6. Click **Create secret key**.
7. The dialog shows the key value. **Copy it now** — OpenAI shows it only once. The key starts with `sk-`.
8. Paste the key into the Hub's **Settings...** dialog or the setup script when it asks for the OpenAI key.

For new OpenAI agents, prefer the **OpenAI Responses** provider option with the endpoint:

```text
https://api.openai.com/v1/responses
```

The same OpenAI API key can be used for multiple OpenAI-backed agents as long as your account has access to the selected model.

**If something goes wrong:** the most common issue is "rate limit exceeded" if you make many requests fast. The Hub has built-in pacing that should prevent this for normal use. If you get billing-related errors, check that the payment method is valid and the **Usage limits** tab isn't set to $0.

---

## Google (Gemini)

**What it powers in the Hub:** Trident, the Research/Synthesis agent.

1. Open <https://aistudio.google.com/app/apikey> in your browser.
2. **Sign in** with your Google account (any Gmail account works).
3. If prompted, accept the AI Studio terms of service.
4. Click **Create API Key** (or **+ Create API key in new project** if you have no projects yet).
5. The key appears in the list. Click the key value to copy it. The key starts with `AIzaSy`.
6. Paste the key into the Hub's **Settings...** dialog or the setup script when it asks for the Gemini key.

Unlike most providers, Google doesn't hide the key after creation — you can copy it from the same page later if you lose it.

**If something goes wrong:** Google AI Studio has a free tier that should cover casual use. If you see quota errors, check the **Usage** tab to see your remaining limit, and look for a "Get more" link if you want a higher quota.

---

## Mistral

**What it powers in the Hub:** Lumen, the Efficiency Specialist agent.

1. Open <https://console.mistral.ai/api-keys> in your browser.
2. **Sign up** or **Sign in**. The free tier doesn't require a payment method.
3. On the API Keys page, click **Create new key** at the top right.
4. Optionally name the key (`InterAI Hub`) and set an expiry — leaving expiry blank means "never".
5. Click **Create new key**.
6. The key value appears once. **Copy it now**. Mistral keys are unprefixed (just a random alphanumeric string, around 32 characters).
7. Paste the key into the Hub's **Settings...** dialog or the setup script when it asks for the Mistral key.

**If something goes wrong:** Mistral's free tier is small but adequate for evaluation. If you hit limits, the **Billing** tab lets you add a payment method to raise them.

---

## Storing keys safely

The setup script writes your keys into:

```text
%APPDATA%\AgentHub\agent-hub-config.json
```

That's `C:\Users\<your-username>\AppData\Roaming\AgentHub\agent-hub-config.json` on a typical Windows machine. The file is readable only by your Windows user account.

**Don't commit this file to GitHub** or share it. It contains your provider API keys in plaintext. Anyone who has the file can spend your providers' credits.

If you suspect a key has leaked, **revoke it** at the provider's dashboard immediately and create a new one. Then update the agent in **Settings...** or re-run the setup script. The script asks before overwriting an existing config and saves a timestamped backup.

---

## Adding more providers later

The Hub's **Settings** dialog (button in the controls panel) lets you add, remove, or edit any agent at any time without re-running the setup script. So if you start with one provider and want to add another later, that's the easier path than re-running the script.

The four providers above are the ones with built-in adapters. Other providers from the broader LLM landscape (Cohere, xAI Grok, Perplexity, Llama-via-Together, DeepSeek, Qwen, etc.) would require new adapters in the Hub source. If there's a specific provider you'd like supported, file a feature request via the **Report a Bug** button (it works for feature requests too).
