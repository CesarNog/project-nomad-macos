# Contributing

Issues and PRs welcome, especially macOS test reports (chip, macOS and Docker Desktop versions, `docker compose -p project-nomad ps`, and `docker compose -p project-nomad logs --tail=100`).

Keep diffs against upstream's compose minimal and document each deviation in the header of `docker-compose.yml`. Run `shellcheck install_mac.sh` before opening a PR.
