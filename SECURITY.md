# Security policy

This private tap is executable distribution infrastructure. Treat changes to package URLs, checksums, install hooks, and GitHub Actions as security-sensitive.

- Never commit credentials, authenticated URLs, or tokens.
- Preserve macOS quarantine metadata and Gatekeeper verification.
- Pin third-party GitHub Actions to full commit hashes.
- Require review for release URL or checksum changes once branch protection is enabled.
- Report suspected compromise privately to the repository owner; do not open a public issue containing credentials or exploit details.
