# uds-package-analytics
UDS package for behavioral analytics

> [!WARNING]  
> This UDS package is an experimental Dash Days project, it is not ready for production use


## Notes
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
