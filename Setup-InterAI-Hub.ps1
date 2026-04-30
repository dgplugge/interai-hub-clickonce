# Setup-InterAI-Hub.ps1
#
# Interactive first-run setup for the InterAI Hub. Walks the user
# through getting an API key from each of four providers (Anthropic,
# OpenAI, Google, Mistral), then writes a working agent-hub-config.json
# to %APPDATA%\AgentHub\.
#
# This script does NOT install the Hub itself — run setup.exe (the
# ClickOnce installer) first. This script is for the AFTER-INSTALL
# step of "I have the Hub, now make it talk to actual LLMs."
#
# Audience: someone comfortable with Windows but new to LLM APIs.
# Each provider section opens the signup page in the default browser
# and gives numbered instructions for finding the "create key" button.
#
# Skip a provider by pressing Enter without pasting a key. You can
# always add it later via the Hub's Settings dialog.
#
# Run from PowerShell:
#     .\Setup-InterAI-Hub.ps1
#
# If Windows blocks execution policy, run instead:
#     powershell -ExecutionPolicy Bypass -File .\Setup-InterAI-Hub.ps1

#Requires -Version 5.1

[CmdletBinding()]
param(
    [switch]$NoBrowser,        # Skip the auto-open of provider URLs
    [switch]$Force             # Overwrite an existing config without prompting
)

$ErrorActionPreference = 'Stop'

# --- Configuration target ---
$AppDataDir = Join-Path $env:APPDATA 'AgentHub'
$ConfigPath = Join-Path $AppDataDir 'agent-hub-config.json'

# --- Provider catalog ---
# Each entry: signup URL, what to click for, default agent seeds,
# minimum-length sanity check on the pasted key.
$Providers = @(
    [pscustomobject]@{
        Id          = 'anthropic'
        Name        = 'Anthropic (Claude)'
        SignupUrl   = 'https://console.anthropic.com/settings/keys'
        SignupSteps = @(
            'Sign up or sign in (no credit card required for the trial credit).',
            'Click "Create Key" near the top right.',
            'Give the key any name you like (e.g., "InterAI Hub").',
            'Copy the key value (starts with sk-ant-...) before closing the dialog — it is shown only once.'
        )
        KeyPrefix   = 'sk-ant-'
        Agents      = @(
            [pscustomobject]@{
                Name = 'Pharos'
                Provider = 'anthropic'
                ApiEndpoint = 'https://api.anthropic.com/v1/messages'
                Model = 'claude-opus-4-6'
                Role = 'Lead Coder and AI Architect'
                SystemPrompt = 'You are Pharos. You are ONE agent in a multi-agent round table. Other agents are SEPARATE AI instances running on DIFFERENT platforms. You CANNOT speak for them. You MUST only respond as yourself. You are the Lead Coder and AI Architect. Respond concisely and focus on implementation, architecture, and code.'
            }
        )
    }
    [pscustomobject]@{
        Id          = 'openai'
        Name        = 'OpenAI (GPT-4o, o3-mini)'
        SignupUrl   = 'https://platform.openai.com/api-keys'
        SignupSteps = @(
            'Sign up or sign in. Add a payment method (small balance is enough — typical use is pennies per session).',
            'Click "Create new secret key" at the top right.',
            'Name the key (e.g., "InterAI Hub") and click Create.',
            'Copy the key value (starts with sk-...) before closing the dialog — it is shown only once.'
        )
        KeyPrefix   = 'sk-'
        Agents      = @(
            [pscustomobject]@{
                Name = 'Lodestar'
                Provider = 'openai'
                ApiEndpoint = 'https://api.openai.com/v1/chat/completions'
                Model = 'gpt-4o'
                Role = 'Systems Architect'
                SystemPrompt = 'You are Lodestar. You are ONE agent in a multi-agent round table. Other agents are SEPARATE AI instances running on DIFFERENT platforms. You CANNOT speak for them. You MUST only respond as yourself. You are the Systems Architect and Design Advisor. Focus on architectural soundness, safety rails, and design philosophy.'
            }
            [pscustomobject]@{
                Name = 'Forge'
                Provider = 'openai'
                ApiEndpoint = 'https://api.openai.com/v1/chat/completions'
                Model = 'o3-mini'
                Role = 'Reasoner'
                SystemPrompt = 'You are Forge. You are ONE agent in a multi-agent round table. Other agents are SEPARATE AI instances running on DIFFERENT platforms. You CANNOT speak for them. You MUST only respond as yourself. You are the Design/Build Specialist. Translate architectural guidance into concrete implementation tasks.'
            }
            [pscustomobject]@{
                Name = 'SpinDrift'
                Provider = 'openai'
                ApiEndpoint = 'https://api.openai.com/v1/chat/completions'
                Model = 'gpt-4o'
                Role = 'Reviewer/Integrator'
                SystemPrompt = 'You are SpinDrift. You are ONE agent in a multi-agent round table. Other agents are SEPARATE AI instances running on DIFFERENT platforms. You CANNOT speak for them. You MUST only respond as yourself. You are the Reviewer/Integrator. Consolidate proposals from other agents, identify gaps, and produce actionable merged plans.'
            }
        )
    }
    [pscustomobject]@{
        Id          = 'gemini'
        Name        = 'Google (Gemini)'
        SignupUrl   = 'https://aistudio.google.com/app/apikey'
        SignupSteps = @(
            'Sign in with your Google account.',
            'If prompted, accept the AI Studio terms.',
            'Click "Create API Key" or "+ Create API key in new project".',
            'Copy the key value (starts with AIzaSy...) — it is also visible later in the same page.'
        )
        KeyPrefix   = 'AIza'
        Agents      = @(
            [pscustomobject]@{
                Name = 'Trident'
                Provider = 'gemini'
                ApiEndpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent'
                Model = 'gemini-2.5-flash'
                Role = 'Research/Synthesis'
                SystemPrompt = 'You are Trident, powered by Google Gemini. You are ONE agent in a multi-agent round table. Other agents are SEPARATE AI instances running on DIFFERENT platforms. You CANNOT speak for them. You MUST only respond as yourself. You provide analysis, research support, and cross-agent synthesis.'
            }
        )
    }
    [pscustomobject]@{
        Id          = 'mistral'
        Name        = 'Mistral AI'
        SignupUrl   = 'https://console.mistral.ai/api-keys'
        SignupSteps = @(
            'Sign up or sign in (free tier available; payment method required for higher rate limits).',
            'Click "Create new key" at the top right.',
            'Optionally name the key and set an expiry — leave blank for never.',
            'Copy the key value before closing the dialog — it is shown only once.'
        )
        KeyPrefix   = ''
        Agents      = @(
            [pscustomobject]@{
                Name = 'Lumen'
                Provider = 'mistral'
                ApiEndpoint = 'https://api.mistral.ai/v1/chat/completions'
                Model = 'mistral-large-latest'
                Role = 'Efficiency Specialist'
                SystemPrompt = 'You are Lumen. You are ONE agent in a multi-agent round table. Other agents are SEPARATE AI instances running on DIFFERENT platforms. You CANNOT speak for them. You MUST only respond as yourself. You are powered by Mistral. Your role is Efficiency and Compression Specialist. Focus on token optimization, protocol compression, and streamlined agent-to-agent communication.'
            }
        )
    }
)

# --- Console helpers ---
function Write-Banner {
    Write-Host ''
    Write-Host '================================================================' -ForegroundColor Cyan
    Write-Host '   InterAI Hub — First-Time Setup' -ForegroundColor Cyan
    Write-Host '================================================================' -ForegroundColor Cyan
    Write-Host ''
    Write-Host 'This script will help you connect the Hub to four AI providers:' -ForegroundColor White
    Write-Host '  - Anthropic (Claude)' -ForegroundColor White
    Write-Host '  - OpenAI    (GPT-4o, o3-mini)' -ForegroundColor White
    Write-Host '  - Google    (Gemini)' -ForegroundColor White
    Write-Host '  - Mistral' -ForegroundColor White
    Write-Host ''
    Write-Host 'For each provider, you will:' -ForegroundColor White
    Write-Host '  1. Visit the provider''s API signup page (script can open it for you).' -ForegroundColor White
    Write-Host '  2. Sign up or sign in.' -ForegroundColor White
    Write-Host '  3. Create an API key.' -ForegroundColor White
    Write-Host '  4. Paste the key back into this window.' -ForegroundColor White
    Write-Host ''
    Write-Host 'You can SKIP any provider by pressing Enter without pasting a key.' -ForegroundColor Yellow
    Write-Host 'You can always add or change keys later from the Hub''s Settings.' -ForegroundColor Yellow
    Write-Host ''
}

function Write-Section {
    param([int]$Step, [int]$TotalSteps, [string]$Title)
    Write-Host ''
    Write-Host ('-' * 64) -ForegroundColor DarkGray
    Write-Host ("Step $Step of $TotalSteps : $Title") -ForegroundColor Cyan
    Write-Host ('-' * 64) -ForegroundColor DarkGray
}

function Read-ApiKey {
    param(
        [string]$ProviderName,
        [string]$KeyPrefix
    )

    while ($true) {
        Write-Host ''
        Write-Host "Paste your $ProviderName API key, or press Enter to skip:" -ForegroundColor Yellow -NoNewline
        Write-Host ' '
        $pasted = Read-Host -Prompt '>'
        if ($null -eq $pasted) {
            Write-Host "  Skipping $ProviderName (no input)." -ForegroundColor DarkGray
            return $null
        }
        $pasted = $pasted.Trim()

        if ([string]::IsNullOrWhiteSpace($pasted)) {
            Write-Host "  Skipping $ProviderName." -ForegroundColor DarkGray
            return $null
        }

        # Sanity checks
        if ($pasted -like '*your*key*here*' -or $pasted -like '*<*>*' -or $pasted -eq 'sk-...' -or $pasted -eq 'PASTE_KEY_HERE') {
            Write-Host "  That looks like a placeholder, not a real key. Try again." -ForegroundColor Red
            continue
        }

        if ($pasted.Length -lt 20) {
            Write-Host "  That key seems too short ($($pasted.Length) characters). Try again, or press Enter to skip." -ForegroundColor Red
            continue
        }

        if ($KeyPrefix -and -not $pasted.StartsWith($KeyPrefix)) {
            Write-Host "  Heads up: $ProviderName keys usually start with '$KeyPrefix' but yours doesn't." -ForegroundColor Yellow
            Write-Host "  Continue anyway? (Y/n)" -ForegroundColor Yellow -NoNewline
            $confirm = Read-Host -Prompt ' '
            if ($null -eq $confirm) { return $null }
            $confirmTrimmed = $confirm.Trim().ToLower()
            if ($confirmTrimmed -and $confirmTrimmed -notin @('y', 'yes')) {
                continue
            }
        }

        return $pasted
    }
}

function Open-SignupPage {
    param([string]$Url, [string]$ProviderName)

    if ($script:NoBrowser) {
        Write-Host "  --no-browser specified; please open manually: $Url" -ForegroundColor Yellow
        return
    }

    Write-Host ''
    Write-Host "  Press Enter to open the $ProviderName signup page in your default browser," -ForegroundColor White
    Write-Host '  or type "skip" + Enter to open it manually:' -ForegroundColor White -NoNewline
    Write-Host ' '
    $resp = Read-Host -Prompt '>'
    if ($null -eq $resp) {
        Write-Host "  Open manually: $Url" -ForegroundColor Yellow
        return
    }
    if ($resp.Trim().ToLower() -eq 'skip') {
        Write-Host "  Open manually: $Url" -ForegroundColor Yellow
        return
    }
    try {
        Start-Process $Url | Out-Null
    } catch {
        Write-Host "  Failed to open browser. Please open this URL manually:" -ForegroundColor Red
        Write-Host "    $Url" -ForegroundColor White
    }
}

# --- Main ---
Write-Banner

# Existing config check
if (Test-Path $ConfigPath) {
    Write-Host "An existing config was found at $ConfigPath" -ForegroundColor Yellow
    if (-not $Force) {
        Write-Host 'Overwrite it? (y/N)' -ForegroundColor Yellow -NoNewline
        $confirm = Read-Host -Prompt ' '
        if ($null -eq $confirm -or $confirm.Trim().ToLower() -notin @('y', 'yes')) {
            Write-Host 'Cancelled. Existing config preserved.' -ForegroundColor DarkGray
            exit 0
        }
    }
    # Back up the old one
    $backup = "$ConfigPath.bak.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item $ConfigPath $backup
    Write-Host "  Existing config backed up to: $backup" -ForegroundColor DarkGray
}

# Walk through each provider
$collectedAgents = New-Object System.Collections.ArrayList
$providersWithKeys = New-Object System.Collections.ArrayList
$totalSteps = $Providers.Count

for ($i = 0; $i -lt $totalSteps; $i++) {
    $p = $Providers[$i]
    Write-Section -Step ($i + 1) -TotalSteps $totalSteps -Title $p.Name

    Write-Host ''
    Write-Host 'How to get a key:' -ForegroundColor White
    for ($j = 0; $j -lt $p.SignupSteps.Count; $j++) {
        Write-Host ("  $($j + 1). $($p.SignupSteps[$j])") -ForegroundColor White
    }

    Open-SignupPage -Url $p.SignupUrl -ProviderName $p.Name

    $key = Read-ApiKey -ProviderName $p.Name -KeyPrefix $p.KeyPrefix
    if (-not $key) { continue }

    [void]$providersWithKeys.Add($p.Id)

    foreach ($agent in $p.Agents) {
        $entry = [ordered]@{
            name = $agent.Name
            provider = $agent.Provider
            apiEndpoint = $agent.ApiEndpoint
            apiKey = $key
            model = $agent.Model
            systemPrompt = $agent.SystemPrompt
            maxTokens = 2048
            timeoutMs = 30000
            enabled = $true
        }
        [void]$collectedAgents.Add($entry)
        Write-Host ("    + agent: $($agent.Name) -> $($agent.Model) ($($agent.Role))") -ForegroundColor Green
    }
}

# Summary
Write-Host ''
Write-Host ('=' * 64) -ForegroundColor Cyan
Write-Host '   Setup Summary' -ForegroundColor Cyan
Write-Host ('=' * 64) -ForegroundColor Cyan

if ($collectedAgents.Count -eq 0) {
    Write-Host ''
    Write-Host 'You skipped every provider, so no config was written.' -ForegroundColor Yellow
    Write-Host 'Run this script again when you have at least one API key,' -ForegroundColor Yellow
    Write-Host 'or use the Hub''s Settings dialog to add agents manually.' -ForegroundColor Yellow
    Write-Host ''
    exit 0
}

Write-Host ''
Write-Host "Configured $($collectedAgents.Count) agent(s) across $($providersWithKeys.Count) provider(s):" -ForegroundColor White
foreach ($a in $collectedAgents) {
    Write-Host ("  - $($a.name) ($($a.provider) / $($a.model))") -ForegroundColor White
}

# Build the config object and write it
$config = [ordered]@{
    budgetGates = [ordered]@{
        enabled = $true
        windowDays = 1
        globalCapTokens = 0
        perAgentCapTokens = [ordered]@{}
    }
    ui = [ordered]@{
        # Background color for the main Hub window. Any name from
        # System.Drawing.KnownColor works — try "AliceBlue" (default),
        # "GhostWhite", "Lavender", "Honeydew", "WhiteSmoke". Edit and
        # restart the Hub to apply.
        backColor = "AliceBlue"
    }
    agents = $collectedAgents
}

# Per-agent budget caps default to 0 (unlimited within global cap)
foreach ($a in $collectedAgents) {
    $config.budgetGates.perAgentCapTokens[$a.name] = 0
}

if (-not (Test-Path $AppDataDir)) {
    New-Item -ItemType Directory -Path $AppDataDir -Force | Out-Null
}

$json = $config | ConvertTo-Json -Depth 6
Set-Content -Path $ConfigPath -Value $json -Encoding UTF8

Write-Host ''
Write-Host "Wrote config: $ConfigPath" -ForegroundColor Green
Write-Host ''
Write-Host 'Next steps:' -ForegroundColor Cyan
Write-Host '  1. Launch InterAI Hub from the Start menu (or wherever you installed it).' -ForegroundColor White
Write-Host '  2. The first launch will ask for a Journal folder — pick or create one.' -ForegroundColor White
Write-Host '  3. Type a message in the bottom-left "Message" box and click Send.' -ForegroundColor White
Write-Host '  4. Each configured agent will respond in turn.' -ForegroundColor White
Write-Host ''
Write-Host 'To change keys later: open the Hub, click Settings.' -ForegroundColor DarkGray
Write-Host ''
