#!/bin/bash

source vars.sh
cat << EOF > $HOME/.pypirc
[distutils]
index-servers =
  pypi
  pypitest

[pypi]
repository: https://upload.pypi.org/legacy/
username=${python_org_username}
password=${python_org_password}

[pypitest]
repository: https://upload.pypi.org/legacy/
username=${python_org_username}
password=${python_org_password}
EOF

echo $HOME/.pypirc generated for ${python_org_username}


