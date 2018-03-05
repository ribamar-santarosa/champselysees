# bashement

Set of bashscript functions to do miscelaneous things.

The idea is that, instead or creating each file for every script I want to
create, I'll put each one in a function, that will be loaded by
`bashement.sh`.

All the functions in `bashement.sh` starts with `bm_`


## Basic usage:
````
# download and load the script.
wget https://raw.githubusercontent.com/ribamar-santarosa/champselysees/master/bashement/bashement.sh
. ./bashement.sh
# ready to use. alternatively, download default environment
bm_source_newest_env
# install at ~/.champselysees:
bm_install_itself # fetches newest bashement -- but respects the old env. some stuff may not work
bm_update # combination of 2 above
````

## Some functions:

####  function bm_psql_restore_dump
dumps `bm_db_dump_file` into  `bm_db_name`

