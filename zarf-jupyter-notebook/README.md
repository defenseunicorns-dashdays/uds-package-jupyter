# JupyterHub
This repo contains my exploration in create an Zarf package for [JupyterHub](https://z2jh.jupyter.org/en/stable/index.html).

## Origin
This chart was taken from https://hub.jupyter.org/helm-chart/. I could not original repository that the upstream chart was created from otherwise I would have forked it. The specific version of the upstream chart is [3.2.1](https://jupyterhub.github.io/helm-chart/jupyterhub-3.2.1.tgz).

This should be considered a fork of the upstream chart as I intend to customize (abuse?) the helm chart a lot.

## Purpose
The goal of this repo is to create an air-gap 'data science' tooling that can be deployed on top of [UDS Core](https://github.com/defenseunicorns/uds-core) and along side [LeapfrogAI](https://leapfrog.ai)



## TODO LIST:

- [ ] See how hard it would be to fully air gap this package (I think a lot of things are getting downloaded at run time.)
- [ ] Attempt to add GPU support to the notebooks so the notebooks ran run AI/ML code.
- [ ] profit

