# UDS Jupyter Hub Zarf Package

[![Latest Release](https://img.shields.io/github/v/release/defenseunicorns/uds-package-jupyter)](https://github.com/defenseunicorns/uds-package-jupyter/releases)
[![Build Status](https://img.shields.io/github/actions/workflow/status/defenseunicorns/uds-package-jupyter/tag-and-release.yaml)](https://github.com/defenseunicorns/uds-package-jupyter/actions/workflows/tag-and-release.yaml)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/defenseunicorns/uds-package-jupyter/badge)](https://api.securityscorecards.dev/projects/github.com/defenseunicorns/uds-package-jupyter)

> [!WARNING]  
> This UDS Zarf Package is an experimental Dash Days project, it could be the basis for a maintained package but is **NOT** ready for production use.

## Prerequisites

This package relies on [UDS Core](https://github.com/defenseunicorns/uds-core) to be setup within your cluster.

## Flavors

| Flavor | Description | Example Creation |
| ------ | ----------- | ---------------- |
| upstream | Uses upstream images within the package. | `zarf package create . -f upstream` |

## Releases

The released packages can be found in [ghcr](https://github.com/defenseunicorns/uds-package-jupyter/pkgs/container/packages%2Fuds%2Fjupyter).

## UDS Tasks (for local dev and CI)

*For local dev, this requires you install [uds-cli](https://github.com/defenseunicorns/uds-cli?tab=readme-ov-file#install)

> :white_check_mark: **Tip:** To get a list of tasks to run you can use `uds run --list`!

## :unicorn: Dash Days Notes

### Easily Add Userale to Doug Translate

Put the following block into `routes/+layout.svelte`:
```
  onMount(async () => {
    const userale = await import("flagon-userale");
    const changeMe = "me";
    userale.options({
      userId: changeMe,
      autostart: false,
      url: "http://localhost:8100/loki/api/v1/push",
      version: "next",
      logDetails: false,
      sessionID: "this one"
    });

    userale.start();
  });
```

### Changes to Loki

To enable a web app with the userale to send data to Loki, we had to enable CORS in Loki by modifying it's NGINX `loki-gateway`. We did this by modifying the `templates/_helpers.tpl` file located in the [upstream Loki chart](https://github.com/grafana/loki/tree/main/production/helm/loki). That modification is as follows:
```
    location = /loki/api/v1/push {
      if ($request_method = 'OPTIONS') {
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
        #
        # Custom headers and headers various browsers *should* be OK with but aren't
        #
        add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';
        #
        # Tell client that this pre-flight info is valid for 20 days
        #
        add_header 'Access-Control-Max-Age' 1728000;
        add_header 'Content-Type' 'text/plain; charset=utf-8';
        add_header 'Content-Length' 0;
        return 204;
      }
      add_header 'Access-Control-Allow-Origin' '*' always;
      proxy_pass       {{ $writeUrl }}$request_uri;
    }
```
This allows Loki to receive preflight checks from userale and always returns the `Access-Control-Allow-Origin '*'` header to prevent issues with CORS.

The values file for deploying Loki is as follows:
```yaml
loki:
  auth_enabled: false
  commonConfig:
    replication_factor: 1
  storage:
    type: 'filesystem'
singleBinary:
  replicas: 1
```

### Changes To Userale

We discovered that change's to Userale will be required in order to integrate with Loki. Specifically, Userale doesn't send data in a standard JSON format, so the Userale payloads will need to be properly JSON'ified.

- If we decide to go with Elastic + Logstash, these changes won't be necessary.
- Noting that the Elastic licensing is restrictive
