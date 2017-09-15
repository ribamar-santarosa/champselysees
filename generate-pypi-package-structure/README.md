# generate-pypi-package-structure

These are some scripts I use to create a pypi package out of a github repo.


Requirements:
1) have an account at https://pypi.python.org/pypi?%3Aaction=register_form .(You're advised
to not take a password that is similar to one of your other passwords, because you'll have
to let it unencrypted in your .pyrc file, which is very bad security practice. There may
be a more secure way of doing things, but you'll probably need to take the time to research
it by yourself. Also logout immediately after usage -- the design of the system allows a successful
session hijack to steal the account)

2) have an account at https://testpypi.python.org/pypi?%3Aaction=register_form

3) have a clean repo for your project set at github, with only `LICENSE` and `README.md`

4) familiar basic usage of `bash`, `python`, `git`

5) have these pips installed:
````
sudo pip install twine wheel
````

6) Troubleshooting -- be already aware of the problems you might have -- or just skip to the actual steps.

Error:
````
ImportError: cannot import name 'IncompleteRead'
````
Solution:
````
sudo easy_install -U pip
sudo pip install twine wheel
````

Error:
````
error: invalid command 'bdist_wheel'
````
Solution:
````
sudo pip install setuptools  wheels --upgrade
# also check http://www.xavierdupre.fr/app/pymyinstall/helpsphinx/blog/2016/2016-02-27_setup_bdist_wheel.html
````

Problem: keyring showing up
Solution:
````
unset SSH_ASKPASS
````

Problem: keyring showing up persists
````
ps -Ao user,pid,pgid,gid,command | egrep "gnome-keyring-daemon" | sed -e 's/[^ ]* *\([^ ]*\).*/\1/' | xargs   kill -9
sudo mv /usr/bin/gnome-keyring-daemon /usr/bin/gnome-keyring-daemon__removed
````



*Actual Steps:*

1)Change `var.sh` and change your personal data.
2) Have those vars in your enviroment, generate `.pypirc` (if you still don't have it),
close your eyes, fingers crossed and let it roll (no commitment yet, only local commits):
````
source vars.sh
[[ -f  $HOME/.pypirc  ]] || bash ./generate_pypirc.sh
bash ./let_it_roll.sh
````

3) check if you agree to the changes, and commit them. Now you're in your normal flow, add
the desired files to the git repo:
````
pushd ${my_package_name}
git log
git push -u origin $(git rev-parse --abbrev-ref HEAD)
popd
````


5) Now do serious stuff -- register and upload your package PyPi (to be done every time you change the package, so not done by `let_it_roll.sh`):
````
pushd ${my_package_name}
pushd ${arbitrary_root_dirname}/
python setup.py bdist_wheel
python setup.py sdist
twine  upload dist/*
popd
popd
````

6) Verify it at: https://pypi.python.org
````
sudo pip install ${my_package_name}
sudo pip show  ${my_package_name} # you'll find out that there are still many things missing
````


Disclaimmer: the above procedure works for me as of today. In the Python world it's common for
the people not to like much https://en.wikipedia.org/wiki/Design_by_contract or
https://en.wikipedia.org/wiki/Open/closed_principle.
So, these steps are expected to break very soon (as the great documentation
http://peterdowns.com/posts/first-time-with-pypi.html doesn't work anymore, and this one
https://packaging.python.org/tutorials/distributing-packages/ also doesn't, their instructions
will lead to errors that point to https://upload.pypi.org/legacy/, which in the browser returns
Error 404, but actually seems to exits, and https://packaging.python.org/guides/migrating-to-pypi-org/#uploading
, which is deprecated). Just need a new
guy to come and say "hey, I have a new idea of how things should work". Good luck to find
the right documentation again when that happens!




