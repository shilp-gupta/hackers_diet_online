# Docker Deployment

## Overview
- The container runs Debian Bookworm with Apache 2 serving the CGI application at `/cgi-bin/HackDiet.pl`.
- Static documentation from `webdoc` is published under `/hackdiet/online`.
- Application data files live under `/server/pub/hackdiet` (subdirectories such as `Users`, `Sessions`, and `ClusterSync`). Mount this path to persist user data outside the container.

## Build the Image
```sh
docker build -t hackers-diet-online .
```

## Run the Container
Create a host directory for persistent data (for example `./hackdiet-data`), then start the container:
```sh
mkdir -p hackdiet-data
docker run -d \
  --name hackers-diet \
  -p 8080:80 \
  -v "$(pwd)/hackdiet-data:/server/pub/hackdiet" \
  hackers-diet-online
```
- Browse to `http://localhost:8080/cgi-bin/HackDiet.pl` to register a new account or sign in.
- Static documentation is available at `http://localhost:8080/hackdiet/online/`.
- The container entrypoint ensures `/server/pub/hackdiet` (and subdirectories such as `Users`) are owned by `www-data`, so the CGI scripts can create new accounts even when the host volume is mounted.
- If you reuse a previous data directory, remove any leftover account folders in `hackdiet-data/Users` (or pick a new username) before creating a new account; each account corresponds to a directory in that location.
- Optionally set `HDO_COOKIE_DOMAIN` (and `HDO_COOKIE_PATH`) in `docker run` if you serve the app behind a custom hostname—cookies default to the current host when unset.

## Customise Links and Branding
- Many legacy pages reference `https://www.fourmilab.ch`. To serve everything locally, update the files in `webdoc/` before building (for example, replace external URLs with your domain).
- Rebuild the image after making branding changes: `docker build -t hackers-diet-online .`

## Maintenance
- Logs are written to `/var/log/apache2` inside the container; use `docker logs hackers-diet` for quick checks.
- Backup the mounted data directory regularly. It contains all user registrations, logs, and generated charts.
- To stop and remove the service: `docker rm -f hackers-diet`.
