# 2. Analytics Engine Implementation

Date: 2024-01-25

## Status

Pending

## Context

We need to decide on an implementation to go with to provide our behavioral analytics. Ideally this would meet the following:

1. SHALL be able to run offline
2. SHALL be open source
3. SHALL be in active development
4. SHOULD be easy to authorize in government
5. SHOULD be simple to integrate into a client app
6. SHOULD provide simple OOB analytics for people to use

Within the context of this ADR we will evaluate the following:

1. Apache Flagon  
Specifically, [flagon-useralejs](https://github.com/apache/flagon-useralejs) is a Javascript client that tracks events on a web page forwards them to a backend database. We tested this with a Loki deployment in an attempt to use existing tech within the UDS stack.

    **Pros**:
    - Event data is highly configurable with Javascript
    - Simple to integrate in web clients
    - `flagon-userale` can live in Gitlab's registry, making the system air-gappable
    - Doesn't require deploying more pods in the cluster

    **Cons**:
    - `flagon-userale` would require code changes to be compataible with Loki
    - Loki's NGINX gateway service has CORS issues that may require changes to the Loki Helm chart's schema
    - Event data is raw on the backend, meaning that further processing is necessary to make the data useful
    - No built-in dashboard capability, we would need to make our own in Grafana


2. Matomo
    Popular and full-featured user analytics engine based on PHP and MySQL. Tested with the Bitnami chart. Has a robust plugin system, but many features are behind a paywall (which they liberally advertise).

    **Pros**:
    - Easy to setup with a third party Bitnami chart
    - Has a built in easy-to-add javascript tag
    (very similar to Google Analytics)
    - Has a lot of features and plugins available in it's ecosystem
    - Basic features are available offline / airgapped

    **Cons**:
    - Most of the plugins require internet to get or a paid subscription
    - Overall the application feels very upselly
    - Nice to have features like heatmaps are behind paywalls
    - (Minor) They are mostly european which not everyone likes

3. Plausible
    Simple user analytics engine based on Elixir/Phoenix and Postgres. Tested with `docker-compose` and was easy to get up and running. 

    **Pros**:
    - Simple interface
    - Has a built in easy-to-add javascript tag
    - Air-gappable

    **Cons**:
    - No heat maps, only pre-programmable "Goals"
    - Dashboards and charts are pretty "vanilla"
    - (Minor) They are mostly european which not everyone likes
    - No official Helm chart

4. Umami  
    Umami is an privacy-focused analytics engine that deploys as a web app in a container and requires an existing Postgres or MySQL database store analytics data in. While super simple to deploy, the data provided by Umami would be more useful in the context of tracking sales funnels, turnover rates, etc.

    **Pros**:

    - Nice web UI including dashboards and charts
    - Simple to install in a web client (just works!)
    - Event data is configurable and there are many customization options

    **Cons**:
    - No heatmaps
    - Dashboards and charts are pretty "vanilla"
    - No easy way to retrieve data that would be useful in the air-gap
    - No official Helm chart

## Decision

TBD
<!--The change that we're proposing or have agreed to implement.-->

## Consequences

TBD
<!--What becomes easier or more difficult to do and any risks introduced by the change that will need to be mitigated.-->
