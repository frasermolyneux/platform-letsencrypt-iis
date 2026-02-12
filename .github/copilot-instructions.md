# Copilot Instructions

## Project Overview

This project provides PowerShell automation to obtain and rotate Let's Encrypt SSL/TLS certificates for all IIS site bindings using the Posh-ACME module with Cloudflare DNS validation.

## Architecture

- **Entry point**: `rotate-iis-certificates.ps1` orchestrates discovery of IIS sites, certificate issuance/renewal, and binding updates.
- **Helper functions** in `functions/`:
  - `Set-IISCertificate` - Constructs and updates IIS HTTPS bindings with SNI support.
  - `Confirm-CertInstall` - Verifies certificate installation in the store.
  - `Test-CertInstalled` - Checks if a certificate is already installed by thumbprint.
  - `Import-PfxCertInternal` - Imports PFX certificates with exportable private keys.
  - `Remove-OldCert` - Removes previous certificates after rotation.
  - `Get-PfxThumbprint` - Retrieves thumbprint from a PFX file.

## Workflow

1. Script enumerates IIS sites via `Get-Website`.
2. For each HTTPS binding, issues or renews certs using `New-PACertificate` and `Submit-Renewal` with the Cloudflare DNS plugin.
3. Binds the latest certificate to each HTTPS binding, optionally removing old certs.

## Requirements

- Windows Server with IIS and PowerShell 5.1+.
- Posh-ACME and WebAdministration modules (installed/imported at runtime).
- Cloudflare API token passed via `-cloudflareApiKey` parameter (converted to SecureString).
- TLS 1.2 is forced for outbound calls.

## Environment

- `POSHACME_HOME` is set to `C:\ACME` (created if absent).
- Targets Let's Encrypt production (`Set-PAServer LE_PROD`); staging available by toggling the comment.

## Conventions

- SNI is required for host headers on IIS 8+.
- Keep secrets out of logs; the script uses verbose console output but no external telemetry.
- When adding new helper functions, dot-source them in `rotate-iis-certificates.ps1` alongside existing ones.
- Maintain exportable key handling in `Import-PfxCertInternal`.

## Testing

- No automated test suite exists; verify changes by running the script on a test IIS instance with Cloudflare-managed DNS records.
- Use the `build-and-test.yml` and `pr-verify.yml` GitHub Actions workflows for CI validation.
