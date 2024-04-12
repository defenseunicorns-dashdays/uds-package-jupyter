FROM quay.io/jupyter/base-notebook:notebook-7.1.2
# Replace `latest` with an image tag from to ensure reproducible builds:
# https://hub.docker.com/r/jupyter/minimal-notebook/tags/
# Inspect the Dockerfile at:
# https://github.com/jupyter/docker-stacks/tree/HEAD/minimal-notebook/Dockerfile


# install additonal deps
USER root
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    gcc musl-dev python3-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# link jupyterhub-singleuser to /usr/local/bin
RUN ln -s /opt/conda/bin/jupyterhub-singleuser /usr/local/bin/jupyterhub-singleuser

# install additional Python packages
USER ${NB_UID}
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt


# set the default command of the image,
# if you want to launch more complex startup than the default `juptyerhub-singleuser`.
# To launch an image's custom CMD instead of the default `jupyterhub-singleuser`
# set `singleuser.cmd: null` in your config.yaml