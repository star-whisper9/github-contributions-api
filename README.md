# GitHub Contributions API v4

A fork of [GitHub Contributions API](https://github.com/grubersjoe/github-contributions-api).

## What I changed

I didn't make any changes to the code; it remains **as is**.

## What I added

Overall, it's only related to container.

- Dockerfile
- A workflow to build and push Docker images to ghcr.
- A public ghcr package(related to this repository) that you can use directly without building the image by yourself.

## docker-compose.yaml example

```yaml
services:
    github-contributions-api:
        image: ghcr.io/star-whisper9/github-contributions-api:latest
        container_name: github-contributions-api
        environment:
          - PORT=3000
        ports:
        # recommand: use localhost bind for security reason
        # see https://docs.docker.com/engine/network/packet-filtering-firewalls/#docker-and-ufw for details
        - 127.0.0.1:3000:3000
        restart: unless-stopped
        healthcheck:
            test:
                [
                "CMD",
                "wget",
                "--quiet",
                "--tries=1",
                "--spider",
                "http://localhost:3000/",
                ]
            interval: 30s
            timeout: 10s
            retries: 3
            start_period: 40s
```