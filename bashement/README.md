# bashement

Set of bashscript functions to do miscelaneous things.

The idea is that, instead or creating each file for every script I want to
create, I'll put each one in a function, that will be loaded by
`bashement.sh`.

All the functions in `bashement.sh` starts with `bm_`

There are 2 files: one `bashement.sh` (containing functions) and another
`bashement-env.sh` (containing examples or sensitive default values for
each var expected to be set by the functions of `bashement.sh`). They
can be updated separately, but this flexibility makes the initial usage
slightly more complex.

## Basic usage:
````
# download and load the script.
wget --no-cache https://raw.githubusercontent.com/ribamar-santarosa/champselysees/master/bashement/bashement.sh
. ./bashement.sh

# ready to use, but it's highly recommended in the first run: download default environment (overrides the current one) to the location set by bm_bashement_env_path, or /tmp/environment-env.sh if not set):
bm_source_newest_env

# whenever needed, reload that  environment (without download, so if you made your changes to the file, they will be preserved)
bm_source_env

# downloads and loads itself (update functions, but preserves both bashement-env.sh and the environment vars)
bm_install_itself

bm_update # combination of 2 above
````

## Some functions:

####  function bm_psql_restore_dump
dumps `bm_db_dump_file` into  `bm_db_name`, using the credentials
`bm_db_name`, `bm_db_user` at `bm_db_host`; becomes interactive
if `bm_db_password` is not set.

````
export  bm_db_dump_file='pg_dump'
bm_psql_restore_dump
````


## Output policy:


Output policy for this script:
- `/dev/stderr` can have anything output
- `/dev/stdout`, depends on the function, but
only objects that the function is
"returning", ie, it will take into consideration
things like backwards compatibily, and are
supposed to be trustworthy -- it still won't
derive legal rights for you, but you have moral
rights to punch developers' faces if it
changes.

