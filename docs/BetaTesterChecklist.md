# Beta Tester Checklist

Use this checklist for the first external tester pass. A useful test takes about 20-30 minutes if you already have at least one provider API key.

## Install

1. Download `setup.exe` from the latest beta release:

   <https://github.com/dgplugge/interai-hub-clickonce/releases>

2. Run `setup.exe`.
3. Accept any normal Windows first-run prompts for unsigned beta software.
4. Launch **InterAI Hub** from the Start menu.

Expected result: the Hub opens, asks for a Journal folder if needed, and shows the main window.

## Configure One Agent

1. Click **Settings...**.
2. Select an existing agent or click **Add New**.
3. Enter provider, endpoint, model, API key, max tokens, and timeout.
4. Click **Test Connection**.
5. Click **Save**.
6. Close Settings.

Expected result: the agent appears in the main roster and the activity log reports it as ready.

## Check Registry Help

1. Click **Model Registry...**.
2. Confirm the model list opens.
3. Select a row and verify the provider/help links are visible or usable.
4. Close the registry.

Expected result: a tester can find where to register for service and where to create an API key without searching manually.

## Check Prompt Preview

1. Select one or more agents.
2. Type a short canary prompt:

   ```text
   Canary test. Please reply with your model name and one sentence about your role.
   ```

3. Click **Preview**.
4. Confirm the preview shows a separate prompt for each selected agent.
5. Confirm prompt size metrics are visible.

Expected result: each agent preview is separate and includes the expected project, kernel, profile, and user prompt context.

## Send Canary

1. Close Preview.
2. Click **Send**.
3. Wait for the selected agents to respond.

Expected result: at least one configured agent returns a coherent response and the transcript/log remains readable.

## Project Smoke Test

1. Use the **Project** dropdown to select an existing project.
2. Add a new project if you have a test project name available.
3. Switch between projects.

Expected result: project selection works without crashing, and the transcript clears when changing project context.

## Roster Repair

1. Open the roster check or repair action if available.
2. Run the check.
3. Try a harmless repair, such as generating a missing profile card for a test agent.

Expected result: the app reports what changed or clearly reports that no repair was needed.

## Report Feedback

Use **Report a Bug...** in the app, or open:

<https://github.com/dgplugge/interai-hub-clickonce/issues>

Please include:

- Windows version.
- Install result.
- Provider/model tested.
- Whether **Test Connection**, **Preview**, and **Send** passed.
- Any error text from the Hub log.
- Screenshots if the layout looks wrong.
