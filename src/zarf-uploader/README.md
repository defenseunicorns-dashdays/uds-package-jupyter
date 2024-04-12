# :warning: Experimental Zarf Uploader

This Zarf package provides an experimental method for uploading Python dependencies to a Gitea server.

### Prereqs
- Gitea installed using Zarf

Deploying this package will grab the Python dependencies from the `requirements.txt` and upload them to the Zarf Gitea server. This enables users to `pip install` Python dependencies from the Gitea server.
