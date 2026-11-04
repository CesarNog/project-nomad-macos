# Project N.O.M.A.D. on macOS (Docker Desktop) — UNTESTED community adaptation

Derived from [Crosstalk-Solutions/project-nomad](https://github.com/Crosstalk-Solutions/project-nomad) (Apache-2.0). The upstream installer supports Debian-based Linux only. **This variant has not been run end-to-end.** Use at your own risk; it mounts `docker.sock` and has no UI authentication.

## Use
```bash
./install_mac.sh        # creates .env with random secrets, then `docker compose up -d`
```
UI: http://localhost:8080 — logs (Dozzle): http://localhost:9999. Data: `~/nomad-data/storage` (override with `NOMAD_STORAGE_PATH=... ./install_mac.sh` before first run).

## Differences from upstream `install/management_compose.yaml`
- Storage under `$HOME` instead of `/opt/project-nomad` (admin relocates child-app mounts from `NOMAD_STORAGE_PATH`).
- MySQL/Redis on named volumes.
- Updater sidecar removed (hardcodes `/opt/project-nomad/compose.yml`). Update: `git pull && docker compose pull && docker compose up -d`.
- `disk-collector` without `:rslave`; it reports the Docker VM disk, not the Mac disk.
- Ports bound to 127.0.0.1.

## Known limitations
- The upstream `project-nomad` image is published for `linux/amd64` only (checked: config blob `architecture: amd64`). Apple Silicon needs emulation (Rosetta/QEMU). Child apps (Kiwix, Ollama, ...) were not checked.
- Needs `ghcr.io` reachable from the Docker daemon.
- Ollama GPU acceleration on Mac is not covered.

## Reset (destructive)
`docker compose -p project-nomad down -v` deletes the MySQL/Redis volumes. Delete `.env` only together with them, or MySQL keeps the old passwords.
