# Copilot Instructions

- Purpose: PowerShell automation to rotate Let's Encrypt certificates across IIS sites using Posh-ACME with Cloudflare DNS validation.
- Entry points: `rotate-iis-certificates.ps1` orchestrates discovery of IIS sites, certificate issuance/renewal, and binding updates.
- Local functions: helpers under `functions/` (`Set-IISCertificate`, `Confirm-CertInstall`, `Test-CertInstalled`, `Import-PfxCertInternal`, `Remove-OldCert`, `Get-PfxThumbprint`) manage certificate import, binding creation, SNI handling, and cleanup.
- Workflow: script enumerates sites via `Get-Website`, issues/renews certs (`New-PACertificate`, `Submit-Renewal`) using Cloudflare plugin, then binds the latest cert to each HTTPS binding, optionally removing old certs.
- Requirements: Windows with IIS and PowerShell 5.1+; Posh-ACME and WebAdministration modules are installed/imported at runtime. Cloudflare API token is passed via `-cloudflareApiKey` (converted to SecureString for plugin args). TLS12 forced for outbound calls.
- Environment: sets `POSHACME_HOME` to `C:\ACME` if absent; targets Let's Encrypt production (`Set-PAServer LE_PROD`), staging available by toggling comment.
- Binding rules: SNI required for host headers on IIS 8+; `Set-IISCertificate` constructs bindings, respects SNI flags, and updates SSL bindings while optionally removing old certificates.
- Telemetry/logging: script is verbose in the console; no external telemetry. Keep secrets out of logs.
- Testing: no automated tests; verify by running script on a test IIS instance with Cloudflare-managed DNS records pointing at the host.
- Extending: when adding new helpers, dot-source them in `rotate-iis-certificates.ps1` alongside existing ones. Maintain exportable key handling in `Import-PfxCertInternal`.
