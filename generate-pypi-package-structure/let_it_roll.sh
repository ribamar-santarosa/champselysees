#!/bin/bash
source vars.sh
git clone $my_package_clone_url
pushd ${my_package_name}
mkdir -p ${arbitrary_root_dirname}/${my_package_name}
touch  ${arbitrary_root_dirname}/
for i in setup.py setup.cfg LICENSE.txt README.md  ; do echo  touch  ${arbitrary_root_dirname}/${i} ; done
for i in __init__.py ${my_file_list}  ; do  touch  ${arbitrary_root_dirname}/${my_package_name}/${i} ; done
cp LICENSE root-dir/LICENSE.txt
cp README.md root-dir/README.md

cat  << 'EOF'  > ${arbitrary_root_dirname}/${my_package_name}/${my_main_file}
# just a random function
def printIfTrue(m, prefix = ''):
  import sys
  if m:
    print(prefix + m)
    sys.stdout.flush()
  return m

if __name__ == '__main__':
  printIfTrue(False, 'tool test:')
  printIfTrue('True', 'tool test:')
EOF

python ${arbitrary_root_dirname}/${my_package_name}/${my_main_file}
# tool test:True


cat <<  EOF > ${arbitrary_root_dirname}/setup.py
# from distutils.core import setup
from setuptools import setup
setup(
  name = "${my_package_name}",
  packages = ["${my_package_name}"],
  version = "${my_package_version}",
  description = "${my_package_description}",
  author = "${author}",
  author_email = "${author_email}",
  url = "${my_package_url}",
  download_url = "${my_package_download_url}",
  keywords = ["testing", "example"],
  classifiers = [],
)

EOF

cat <<  EOF > ${arbitrary_root_dirname}/setup.cfg
[metadata]
description-file = README.md
EOF

git tag ${my_package_version} -m "tag ${my_package_version} for generation of tar.gz"

file=${arbitrary_root_dirname}  ; git add $file ; git commit -m "$file: added initial structure for pypi"  


cat <<  EOF > troubleshooting_${my_package_name}.py
import sys
import imp
E = BaseException
try:
  import ${my_package_name}
except E, e:
  print("${my_package_name} not imported")
print('system paths are:')
print(sys.path)
imp.load_source('${my_package_name}', '/usr/local/lib/python2.7/dist-packages/pychampselysees/${my_package_name}.py') # see correct location with pip show  ${my_package_name} output

import ${my_package_name}
${my_package_name}.printIfTrue('imp.load_source loads ${my_package_name}. package is working.')
print('imp.find_module(${my_package_name}):')
print(imp.find_module('${my_package_name}'))

del  ${my_package_name}
try:
  ${my_package_name}.printIfTrue('package is deleted so, this must raise exception')
except E, e:
  print('package is deleted so, this exception is correct')
  print("${my_package_name} not imported")

import ${my_package_name}
try:
  ${my_package_name}.printIfTrue('package is import so, this must NOT raise exception -- this message print means success')
except E, e:
  print('package is deleted so, this exception is incorrect')
  print("${my_package_name} not imported")

EOF


popd

