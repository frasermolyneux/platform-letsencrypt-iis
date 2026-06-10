# platform-letsencrypt-iis

[![Build and Test](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/build-and-test.yml)
[![Code Quality](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/codequality.yml/badge.svg)](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/codequality.yml)
[![Deploy Prd](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/deploy-prd.yml/badge.svg)](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/deploy-prd.yml)
[![Copilot Setup Steps](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/copilot-setup-steps.yml/badge.svg)](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/copilot-setup-steps.yml)
[![Dependabot Auto-Merge](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/dependabot-automerge.yml/badge.svg)](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/dependabot-automerge.yml)
[![PR Verify](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/pr-verify.yml/badge.svg)](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/pr-verify.yml)

## Documentation

* [Documentation Home](docs/README.md)

## Overview

This project provides PowerShell automation to obtain and rotate Let's Encrypt SSL/TLS certificates for all IIS site bindings using the Posh-ACME module. It discovers sites via `Get-Website`, requests and renews certificates through Cloudflare DNS validation, and updates HTTPS bindings with SNI support. Helper functions under `functions/` handle certificate import, binding configuration, thumbprint retrieval, and cleanup of old certificates.

## Contributing

Please read the [contributing](CONTRIBUTING.md) guidance; this is a learning and development project.

## Security

Please read the [security](SECURITY.md) guidance; I am always open to security feedback through email or opening an issue.

## Local dev: MCP wire-up

This repo is wired to consume the shared `frasermolyneux-copilot` MCP server defined in `frasermolyneux/.github-copilot` (pinned via `.github/workflows/copilot-setup-steps.yml` and declared in `.github/copilot/mcp_config.json`). For setup, the tool surface, and client-specific configuration snippets, see [`mcp-server/README.md`](https://github.com/frasermolyneux/.github-copilot/blob/v0.1.0/mcp-server/README.md) in the shared config repo.

