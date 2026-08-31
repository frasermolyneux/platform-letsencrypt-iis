# AGENTS.md — platform-letsencrypt-iis

Windows/PowerShell automation repo. `rotate-iis-certificates.ps1` + `functions/*.ps1` renew Let's Encrypt certificates (Posh-ACME, Cloudflare DNS validation) and rebind them to every HTTPS IIS site binding. No app framework, no database, no Terraform root here.

> Humans: prefer `.github/copilot-instructions.md` for project orientation. This file is the agent execution brief.

---

## Safety and deployment boundaries

- **Admin/production-only runtime.** The script mutates `Cert:\LocalMachine\My`, IIS bindings (`Get-WebBinding`/`New-WebBinding`/`Set-WebBinding`), and `IIS:\SslBindings` via the `WebAdministration` module. That requires local administrator rights and IIS installed — neither exists on a standard Ubuntu Copilot cloud runner, nor on a Windows box without the IIS role.
- **Real production execution only happens via `deploy-prd.yml`** on the self-hosted Windows runner `NS570403`, gated by the `Production` GitHub environment and the `CLOUDFLARE_API_KEY` secret. Never attempt to run `rotate-iis-certificates.ps1` end-to-end elsewhere — it renews real certs against Let's Encrypt production (`LE_PROD`) and rebinds live sites.
- **Schedule** lives in the workflow, not an OS Scheduled Task: `deploy-prd.yml` triggers on push to `main`, weekly (Thursday 03:00 UTC) `schedule:` cron, and manual `workflow_dispatch`.
- The Cloudflare API key flows only through `secrets.CLOUDFLARE_API_KEY` → `-cloudflareApiKey` parameter → `SecureString`. Never introduce a hard-coded credential, connection string, or alternate secret path.
- Do not modify `.github/workflows/`, `.github/dependabot.yml`, branch protection, or repository/Actions settings unless that is the explicit task.

---

## Validate changes

These are the exact checks CI runs (`build-and-test.yml` / `pr-verify.yml`, on `windows-latest`):

```pwsh
# Static analysis — matches CI exactly
Install-Module -Name PSScriptAnalyzer -Force -Scope CurrentUser
Invoke-ScriptAnalyzer -Path . -Recurse -Settings PSGallery

# Syntax check every script
Get-ChildItem -Path . -Filter *.ps1 -Recurse | ForEach-Object {
    [System.Management.Automation.PSParser]::Tokenize((Get-Content $_.FullName -Raw), [ref]$null) | Out-Null
}
```

- No Pester tests exist (`**/*.Tests.ps1` — none in this repo). Don't add a test framework unless asked.
- No `.editorconfig`, no Terraform root, no dotnet/npm/lockfile anywhere in this repo — don't invent build/format commands for stacks that aren't here.
- `git diff --check` catches whitespace issues on any diff you produce.
- PSScriptAnalyzer and the syntax tokenizer are cross-platform (pwsh) and safe to run anywhere, including Ubuntu. **IIS binding / certificate-store / scheduled-rotation behavior cannot be runtime-validated off a Windows host with IIS installed** — state plainly in your summary when that validation was not performed (it wasn't possible on this workstation: no `WebAdministration` module, no IIS role).

---

## Custom agents

No `.github/agents/` directory exists in this repo. There is nothing to audit and none should be added for routine work here.