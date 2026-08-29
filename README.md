# docker-agent-browser

Docker image for [vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser).

Use this image to run the `agent-browser` CLI inside Docker without installing Node.js, Chrome, or system dependencies on your host.

## Usage

### Build

```bash
docker build -t docker-agent-browser .
```

The following build arguments can be overridden:

| Argument | Default | Description |
|---|---|---|
| `BASE_IMAGE` | `node:24-trixie-slim` | Base Node.js image |
| `AGENT_BROWSER_VERSION` | *(latest)* | Version of `agent-browser` to install |

Example:

```bash
docker build \
  --build-arg BASE_IMAGE=node:24-trixie-slim \
  --build-arg AGENT_BROWSER_VERSION=0.1.0 \
  -t docker-agent-browser .
```

### Run

Start a long-running container so you can `docker exec` into it per session:

```bash
docker run -d --name agent-browser docker-agent-browser
```

### Execute

```bash
docker exec -it agent-browser agent-browser --help
```

## License

MIT License. See [LICENSE](./LICENSE).
