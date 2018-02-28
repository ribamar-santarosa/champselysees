#!/usr/bin/env bash


function bm_help {
  echo "This is bashement.sh. Help yourself."
}


# function bm_psql_restore_dump
# dumps $bm_db_dump_file into
# bm_db_name
#
# * expects:
# bm_db_host, bm_db_user, bm_db_name,
# bm_db_dump_file (which file must
# exist), bm_db_password
# * becomes interactive if not given:
# bm_db_password
# * requires:
# sudo, postgres, psql
# * destroys:
# database bm_db_name in psql
# * (over)writes:
# database bm_db_name in psql,
# file bm_out_psql_restore,
# bm_out_psql_restore_query
# PGPASSWORD
#
function bm_sudo_psql_restore_dump {
  sudo  su -  postgres bash -c "dropdb  ${bm_db_name}"
  sudo  su -  postgres bash -c "createdb  ${bm_db_name}"

  PGPASSWORD="${bm_db_password}"   psql -h  ${bm_db_host} -U ${bm_db_user} ${bm_db_name} --set ON_ERROR_STOP=off  <  ${bm_db_dump_file} | tee "${bm_out_psql_restore}"
  export bm_query=" select tablename from pg_tables; "
  echo "$bm_query"  | PGPASSWORD="${bm_db_password}"    psql  -h ${bm_db_host} -U ${bm_db_user} ${bm_db_name}  | tee "${bm_out_psql_restore_query}"
}
