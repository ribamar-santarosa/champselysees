#!/usr/bin/env bash

# Output policy for this script:
# /dev/stderr can have anything output
# /dev/stdout, depends on the function, but
# only objects that the function is
# "returning"

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

function bm_git_clone_and_pull {
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
# bm_ensure_dirname_exists
#  wget
#
# *(over)writes:
# bm_ensure_dirname_path
#
function bm_wget_download {
  export bm_ensure_dirname_path="${bm_wget_output_path}"
  bm_ensure_dirname_exists
  (wget --spider "${bm_wget_url}") && (wget "${bm_wget_url}" --output-document "${bm_wget_output_path}")
}


# bm_source_env
# sources the newest version of the
# default env file for this script
# * expects:
# bm_bashement_env_path
# * fallbacks:
#  bm_bashement_env_path="/tmp/bashement-env.sh"
# bm_bashement_path
# * becomes interactive:
#
# * requires
#
# *(over)writes:
function bm_source_env {
  # fallbacks:
  [[ -z "${bm_bashement_env_path}" ]] && export bm_bashement_env_path="/tmp/bashement-env.sh"
  . "${bm_bashement_env_path}"
}


# bm_source_newest_env
# downloads the newest version of the
# default env file for this script
# and sources it
# * expects:
# bm_bashement_raw_url,
# bm_bashement_env_path
# * fallbacks:
# bm_bashement_env_raw_url="https://raw.githubusercontent.com/ribamar-santarosa/champselysees/master/bashement/bashement-env.sh"
#  bm_bashement_env_path="/tmp/bashement-env.sh"
# bm_bashement_path
# * becomes interactive:
#
# * requires
#  bm_wget_download
#
# *(over)writes:
# bm_wget_url,
# bm_wget_output_path,
# environment vars set by bm_bashement_env_raw_url
function bm_source_newest_env {
  # fallbacks:
  [[ -z "${bm_bashement_env_raw_url}" ]] && export bm_bashement_env_raw_url="https://raw.githubusercontent.com/ribamar-santarosa/champselysees/master/bashement/bashement-env.sh"
  [[ -z "${bm_bashement_env_path}" ]] && export bm_bashement_env_path="/tmp/bashement-env.sh"
  export bm_wget_url="${bm_bashement_env_raw_url}"
  export bm_wget_output_path="${bm_bashement_env_path}"
  bm_wget_download
  . "${bm_bashement_env_path}"
}


# bm_install_itself
# downloads the newest version of this script,
# sources it.
# note that it requires a previously env
# to be loaded.
# * expects:
# bm_bashement_raw_url,
# bm_bashement_path
# * becomes interactive:
#
# * requires
#  bm_wget_download
#
# *(over)writes:
# bm_wget_url,
# bm_wget_output_path
#
function bm_install_itself {
  export bm_wget_url="${bm_bashement_raw_url}"
  export bm_wget_output_path="${bm_bashement_path}"
  bm_wget_download
  . "${bm_bashement_path}"
}


# bm_update_itself
# downloads the latest version of this
# script's environment, of this script,
# sources it.
# * expects:
#
# * becomes interactive:
#
# * requires
#  bm_source_newest_env,
#  bm_install_itself
#
# *(over)writes:
#
function bm_update_itself {
  bm_source_newest_env
  bm_install_itself
}


# bm_install
# downloads the newest version of this script,
# sources it and installs champselysees.
# note that it requires a previously env
# to be loaded.
# * expects:
# bm_bashement_raw_url,
# bm_bashement_path
# * becomes interactive:
#
# * requires
#  bm_wget_download,
#  bm_champselysees_install
#
# *(over)writes:
# bm_wget_url,
# bm_wget_output_path
#
function bm_install {
  export bm_wget_url="${bm_bashement_raw_url}"
  export bm_wget_output_path="${bm_bashement_path}"
  bm_wget_download
  . "${bm_bashement_path}"
  bm_champselysees_install
}


# bm_update
# downloads the latest version of this
# script's environment, of this script,
# sources it and installs champselysees.
# * expects:
#
# * becomes interactive:
#
# * requires
#  bm_source_newest_env,
#  bm_install_itself
#
# *(over)writes:
#
function bm_update {
  bm_source_newest_env
  bm_install
}


# bm_export
#
# * expects:
# bm_export_var,
# bm_export_value
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
#
# *(over)writes:
# env var having bm_export_var as name
#
function bm_export {
  export ${bm_export_var}=${bm_export_value}
}


# bm_resolve
# returns the value of the having having
# the name stored in the value of bm_resolve_var.
# "dereferences" bm_resolve_var.
# 
# * expects:
# bm_echo_command,
# bm_resolve_var
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
#
# *(over)writes:
# bm_resolve_tmp_var
#
function bm_resolve {
  export bm_resolve_tmp_var=$(echo  ${bm_resolve_var})
  ${bm_echo_command} ${!bm_resolve_tmp_var}

}


# bm_fallback
#
# * expects:
# bm_fallback_var,
# bm_fallback_to
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
#
# *(over)writes:
# bm_export_var,
# bm_export_value
#
function bm_fallback {
  export bm_export_var=${bm_fallback_var}
  export bm_export_value=${bm_fallback_to}
  test -z "$(bm_resolve ${bm_fallback_value})" && bm_export
}


# function bm_psql_generate_dump
# dumps bm_db_name
# into $bm_db_dump_file (if non existing)
#
# * expects:
# bm_db_host, bm_db_user, bm_db_name,
# bm_db_dump_file (must
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
function bm_psql_generate_dump {
  [[  -f  "${bm_db_dump_file}"   ]] &&   echo "${bm_db_dump_file} exists" || (   ( PGPASSWORD="${bm_db_password}"  pg_dump  -h  ${bm_db_host} -U ${bm_db_user} ${bm_db_name}  )  |  tee  ${bm_db_dump_file} )     #iffileexists
  echo "Generated (I hope) dump file, if it didn't exist." &> /dev/stderr
  echo "For restoring it (later), export the following var:" &> /dev/stderr
  echo "export bm_db_dump_file='${bm_db_dump_file}'" &> /dev/stderr
}


# bm_assign
# the env var having the name stored
# in the value of bm_assign_to will
# have the same value as of the var
# in bm_assign_var
# * expects:
# bm_assign_to,
# bm_assign_var
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
#
# *(over)writes:
# bm_export_var,
# bm_export_value
#
# function: bm_assign
function bm_assign {
  export bm_export_var=${bm_assign_var}
  export bm_export_value=$(bm_resolve ${bm_assign_value})
  bm_export
}


# bm_namespace_add
#
# * expects:
# bm_echo_command
# bm_namespace_left
# bm_namespace_right
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
#
# *(over)writes:
# env var having bm_export_var as name
#
function bm_namespace_add {
  ${bm_echo_command} ${bm_namespace_left}${bm_namespace_right}
}


# bm_namespace_rm
#
# * expects:
# bm_echo_command
# bm_namespace_left
# bm_namespace_right
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
#
# *(over)writes:
# env var having bm_export_var as name
#
function bm_namespace_rm {
  ${bm_echo_command} ${bm_namespace_left} | sed "s/^${bm_namespace_right}//"
}

# function bm_psql_restore_dump
# dumps $bm_db_dump_file into
# bm_db_name
#
# * expects:
# bm_db_host, bm_db_user, bm_db_name,
# bm_db_dump_file (must
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


# section future:
# TODO: bm_bashement_env_path must be set by any installer of bashement


# section: templates:
# bm_new_function
#
# * expects:
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
#
# *(over)writes:
#
# function: bm_new_function
export bm_new_function_var=
function bm_new_function {
  echo # needs one line
}


