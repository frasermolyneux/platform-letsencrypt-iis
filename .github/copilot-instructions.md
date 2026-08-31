# Copilot Instructions

## Project Overview

PowerShell automation that obtains and rotates Let's Encrypt SSL/TLS certificates for every IIS site HTTPS binding, using Posh-ACME with Cloudflare DNS validation. See `AGENTS.md` for agent execution boundaries.

## Architecture

- **Entry point**: `rotate-iis-certificates.ps1` — discovers IIS sites, issues/renews certs, updates bindings.
- **Helpers** in `functions/`: `Set-IISCertificate` (binding + SNI updates), `Confirm-CertInstall` (verify/import orchestration), `Test-CertInstalled` (thumbprint lookup), `Import-PfxCertInternal` (exportable PFX import), `Remove-OldCert` (cleanup), `Get-PfxThumbprint` (thumbprint from file).

## Workflow

1. Enumerate IIS sites via `Get-Website`.
2. For each HTTPS binding, issue/renew via `New-PACertificate` + `Submit-Renewal` (Cloudflare plugin).
3. Bind the latest cert to each HTTPS binding, optionally removing the old cert.

## Requirements & environment

- Windows Server, IIS, PowerShell 5.1+; Posh-ACME and `WebAdministration` modules imported at runtime.
- Cloudflare API token passed via `-cloudflareApiKey` → `SecureString`. TLS 1.2 forced for outbound calls.
- `POSHACME_HOME` = `C:\ACME` (created if absent). Targets `LE_PROD`; staging via commented toggle.

## Conventions

- SNI required for host headers on IIS 8+.
- No external telemetry; keep secrets out of verbose console logs.
- Dot-source new helper functions in `rotate-iis-certificates.ps1` alongside existing ones.
- Preserve exportable key handling in `Import-PfxCertInternal`.

## Safety

Certificate/binding mutations need local admin rights and an installed IIS role — unavailable on Ubuntu or non-IIS Windows. Real rotation only runs via `deploy-prd.yml` on self-hosted runner `NS570403`.

## Validate

Exact commands, match CI (`build-and-test.yml`/`pr-verify.yml`):

```pwsh
Install-Module -Name PSScriptAnalyzer -Force -Scope CurrentUser
Invoke-ScriptAnalyzer -Path . -Recurse -Settings PSGallery
```

```pwsh
Get-ChildItem -Path . -Filter *.ps1 -Recurse | ForEach-Object {
    [System.Management.Automation.PSParser]::Tokenize((Get-Content $_.FullName -Raw), [ref]$null) | Out-Null
}
```

Cross-platform (pwsh), safe on Ubuntu. No Pester tests exist. IIS/certificate runtime behavior needs a Windows host with IIS — state explicitly if unverified.