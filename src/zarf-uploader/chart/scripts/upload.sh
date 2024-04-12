#!/bin/bash

#####
# Upload all the PyPI packages
#####
twine upload --repository-url=http://zarf-gitea-http.zarf.svc.cluster.local:3000/api/packages/###ZARF_GIT_PUSH###/pypi \
                       --skip-existing \
                       --verbose \
                       -u "###ZARF_GIT_PUSH###" \
                       -p "###ZARF_GIT_AUTH_PUSH###" \
                       /packages/*  
