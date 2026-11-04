# Project N.O.M.A.D. on macOS (Docker Desktop)

[![ci](https://github.com/CesarNog/project-nomad-macos/actions/workflows/ci.yml/badge.svg)](https://github.com/CesarNog/project-nomad-macos/actions/workflows/ci.yml)

Unofficial, experimental Docker Compose adaptation of [Project N.O.M.A.D.](https://github.com/Crosstalk-Solutions/project-nomad) (Node for Offline Media, Archives, and Data) for macOS with Docker Desktop. Upstream officially supports Debian-based Linux only. Not affiliated with Crosstalk Solutions.

## Status

| Environment | Status |
|---|---|
| Linux amd64 (GitHub Actions) | CI starts the stack and `GET /api/health` returns `{"status":"ok"}` |
| macOS 26.7.2 / Apple Silicon / Docker Desktop 4.98.0 (Engine 29.9.2, linux/arm64) (one report) | Stack starts and `GET /api/health` returns `{"status":"ok"}`; the admin image runs under amd64 emulation. Child apps (Kiwix, Ollama, ...) not tested |
| Intel Mac, other macOS versions | **Not validated.** Reports welcome via issues |

Risks: the stack mounts `docker.sock` and the admin UI has no authentication. Use at your own risk.

## Requirements
- Docker Desktop with `docker compose` v2
- Access to `ghcr.io` from the Docker daemon
- Disk space for the content you choose to download (Wikipedia, maps, AI models)

## Troubleshooting
- `error from registry: denied` when pulling `ghcr.io/...`, even for public images: a stale `ghcr.io` login in the Docker credential store can cause it. Fix: `docker logout ghcr.io` (re-login later with a valid token if you need private images), then retry.

## Use
```bash
git clone https://github.com/CesarNog/project-nomad-macos.git
cd project-nomad-macos
./install_mac.sh
```
Creates `.env` with random secrets, then runs `docker compose up -d`. UI: http://localhost:8080. Logs (Dozzle): http://localhost:9999. Data: `~/nomad-data/storage` (set `NOMAD_STORAGE_PATH` before the first run to change it).

Update: `git pull && docker compose -p project-nomad pull && docker compose -p project-nomad up -d`.

## Verify, stop, start, uninstall
```bash
curl -fsS http://localhost:8080/api/health        # expect {"status":"ok"}
docker compose -p project-nomad ps
docker compose -p project-nomad down              # stop (keeps data)
docker compose -p project-nomad up -d             # start again (run from this directory, needs .env)
```
Full uninstall (destructive, deletes database and downloaded content):
```bash
docker compose -p project-nomad down -v
docker ps -a --filter name=nomad_                 # child apps installed from the UI are separate containers; remove them yourself
rm -f .env && rm -rf ~/nomad-data                 # or your NOMAD_STORAGE_PATH
```

## Differences from upstream `install/management_compose.yaml`
- Storage under `$HOME` instead of `/opt/project-nomad` (the admin relocates child-app mounts from `NOMAD_STORAGE_PATH`).
- MySQL and Redis on named volumes.
- Updater sidecar removed (it hardcodes `/opt/project-nomad/compose.yml`).
- `disk-collector` without `:rslave`; it reports the Docker VM disk, not the Mac disk.
- Ports bound to `127.0.0.1`.

## Known limitations
- The upstream `project-nomad` image is `linux/amd64` only (config blob `architecture: amd64`). Apple Silicon needs emulation (Rosetta/QEMU). Child apps (Kiwix, Ollama, ...) were not checked.
- Ollama GPU acceleration on Mac is not covered.

## Reset (destructive)
`docker compose -p project-nomad down -v` deletes the MySQL and Redis volumes. If you delete `.env`, delete the volumes too, or MySQL keeps the old passwords.

## License
Apache-2.0, same as upstream. See [LICENSE](LICENSE) and [NOTICE](NOTICE).
