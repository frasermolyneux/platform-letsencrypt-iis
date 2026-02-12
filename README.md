# platform-letsencrypt-iis

[![Build and Test](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/build-and-test.yml)
[![Code Quality](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/codequality.yml/badge.svg)](https://github.com/frasermolyneux/platform-letsencrypt-iis/actions/workflows/codequality.yml)
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

