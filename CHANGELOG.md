# Changelog

## Unreleased
- README: macOS (Apple Silicon) smoke result and troubleshooting for `ghcr.io` `denied` pulls.

## 0.1.0 (pre-release)
- Initial macOS / Docker Desktop compose adaptation of Project N.O.M.A.D.
- `install_mac.sh` generates `.env` secrets and starts the stack.
- CI: shellcheck, `docker compose config`, and a Linux amd64 smoke test on `/api/health`.
- Not validated on macOS yet.
