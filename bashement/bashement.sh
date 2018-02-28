#!/usr/bin/env bash


function bm_help {
  echo "This is bashement.sh. Help yourself."
}


# clones and pull a git repository
#
# * expects:
# bm_repo_url,
# bm_repo_dir
#
# * becomes interactive:
# bm_repo_url requires password
#
# * requires
#  git
#
# *(over)writes:
# bm_repo_dir contents

function bm_git_clone_and_pull{
  git clone "${bm_repo_url}" "${bm_repo_dir}"
  cd "${bm_repo_dir}"
  git pull
  cd -
}


# installs champselysees, a collection of
# bash and ruby scripts, in
# bm_champselysees_repo_dir
#
# * expects:
# bm_champselysees_repo_url,
# bm_champselysees_repo_dir
#
# * becomes interactive:
# bm_champselysees_repo_url requires password
#
# * requires
# bm_git_clone_and_pull
#
# *(over)writes:
# bm_repo_url, bm_repo_dir

function bm_champselysees_install {
  export bm_repo_url="${bm_champselysees_repo_url}"
  export bm_repo_dir="${bm_champselysees_repo_dir}"
  bm_git_clone_and_pull
}


# bm_ensure_dirname_path
# ensure that the dirname of
# a path exists, creating if
# it doesn't.
# * expects:
#  bm_ensure_dirname_path
# * becomes interactive:
#
# * requires
#
# *(over)writes:
# recursively the dirname of
# bm_ensure_dirname_path in
# the case it doesn't exist
#
# function: bm_ensure_dirname_exists
export bm_ensure_dirname_path=
function bm_ensure_dirname_exists {
  mkdir -p "$(dirname "${bm_ensure_dirname_path}")"
}


# bm_wget_download
# * expects:
# bm_wget_url,
# bm_wget_output_path
# * becomes interactive:
#
# * requires
#  wget
#
# *(over)writes:
# bm_ensure_dirname_path
#
function bm_wget_download {
  export bm_ensure_dirname_path="${bm_wget_output_path}"
  bm_ensure_dirname_exists
  wget "${bm_wget_url}" --output-document "${bm_wget_output_path}"
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
