# platform-letsencrypt-iis

[![Code Quality](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/codequality.yml/badge.svg)](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/codequality.yml)
[![PR Verify](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/pr-verify.yml/badge.svg)](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/pr-verify.yml)
[![Deploy Dev](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/deploy-dev.yml/badge.svg)](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/deploy-dev.yml)
[![Deploy Prd](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/deploy-prd.yml/badge.svg)](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/deploy-prd.yml)

## Documentation

* [Documentation Home](docs/README.md) - Project-specific documentation placeholder

## Overview

PowerShell automation to obtain and rotate Let's Encrypt certificates for all IIS site bindings using the Posh-ACME module. Discovers sites via Get-Website, requests/renews certs via Cloudflare DNS, and updates HTTPS bindings with SNI and cleanup of old certificates.

## Contributing

Please read the contributing guidance; this is a learning and development project.

## Security

Please read the security guidance; I am always open to security feedback through email or opening an issue.

