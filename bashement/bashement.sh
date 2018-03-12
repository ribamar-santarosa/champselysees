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


# bm_export_git_current_branch
#
# * planned changes:
#
# * expects:
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
# git rev-parse --abbrev-ref HEAD,
# bm_export_prepare_value,
#
# *(over)writes:
# bm_export_prepare_var,
# bm_export_prepare_command,
# bm_export_prepare_command_args,
# bm_git_current_branch,
#
function bm_export_git_current_branch {
  export bm_export_prepare_var="bm_git_current_branch"
  export bm_export_prepare_command="git rev-parse --abbrev-ref HEAD"
  export bm_export_prepare_command_args=
  bm_export_prepare_value
}


# bm_export_git_time
# exports bm_git_time
#
# * planned changes:
#
# * expects:
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
# date +"%Y.%m.%d_%H.%M.%S",
# bm_export_prepare_value,
#
# *(over)writes:
# bm_export_prepare_var,
# bm_export_prepare_command,
# bm_export_prepare_command_args,
# bm_git_time,
#
function bm_export_git_time {
  export bm_export_prepare_var="bm_git_time"
  export bm_export_prepare_command="date +\"%Y.%m.%d_%H.%M.%S\""
  export bm_export_prepare_command_args=
  bm_export_prepare_value
}


# bm_derive_git_branch_backup
# derives bm_git_branch_backup,
# from currently set bm_git_time,
# and bm_git_current_branch
#
# * planned changes:
#
# * expects:
#   bm_git_time,
#   bm_git_current_branch
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
# bm_export,
#
# *(over)writes:
# bm_export_var,
# bm_export_value,
# bm_git_branch_backup,
#
function bm_derive_git_branch_backup {
  export bm_export_var="bm_git_branch_backup"
  export bm_export_value="bk-${bm_git_time}-${bm_git_current_branch}"
  bm_export
}


# bm_set_git_branch_backup
# derives bm_git_branch_backup,
# from currently set bm_git_time,
# and bm_git_current_branch
#
# * planned changes:
#
# * expects:
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
# bm_export_git_time,
# bm_export_git_current_branch,
# bm_derive_git_branch_backup
#
# *(over)writes:
#
function bm_set_git_branch_backup {
  bm_export_git_time
  bm_export_git_current_branch
  bm_derive_git_branch_backup
}


# bm_git_update_branch
# backups, forks or clones bm_branch_a,
# into bm_branch_b, at the head
# bm_git_reset_at_head.
# bm_branch_b will be a fork of bm_branch_a,
# reset at the commit's having the hash
# bm_git_reset_at_head.
# set bm_git_reset_and_hard=" " to avoid
# a hard reset.
#
# * planned changes:
#
# * expects:
# bm_git_branch_a,
# bm_git_branch_b,
# bm_git_reset_and_hard,
# bm_git_reset_at_head
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
# bm_fallback,
# bm_export_git_current_branch,
# bm_conditioned_run,
# git checkout,
# git checkout -b,
# git reset --hard,
#
# *(over)writes:
# bm_fallback_var,
# bm_fallback_to,
# bm_conditioned_run_condition_var,
# bm_conditioned_run_command,
#
function bm_git_update_branch {
  export bm_fallback_var="bm_git_reset_and_hard"
  export bm_fallback_to="--hard"
  bm_fallback
  bm_export_git_current_branch
  git checkout ${bm_git_branch_a}
  git checkout ${bm_git_branch_b}  ||  git checkout -b ${bm_git_branch_b}
  export bm_conditioned_run_condition_var="bm_git_reset_at_head"
  export bm_conditioned_run_command="git reset ${bm_git_reset_and_hard} ${bm_git_reset_at_head}"
  bm_conditioned_run
  git checkout ${git_bm_current_branch}
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
  (wget -q --spider --no-cache "${bm_wget_url}") && (wget -q --no-cache "${bm_wget_url}" --output-document "${bm_wget_output_path}")
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
# bm_wget_output_path,
# bm_install_itself_done
#
function bm_install_itself {
  export bm_wget_url="${bm_bashement_raw_url}"
  export bm_wget_output_path="${bm_bashement_path}"
  bm_wget_download
  . "${bm_bashement_path}"
  export bm_install_itself_done="${bm_time}"
}


# bm_install_itself_if_not_done
# bm_install_itself  if bm_install_itself_done
# is not set.
#
# * expects:
# bm_install_itself_done to be set or unset
#
# * becomes interactive:
#
# * requires
#  bm_install_itself,
#  bm_conditioned_run
#
# *(over)writes:
# bm_conditioned_run_condition_var,
#
function bm_install_itself_if_not_done {
  export bm_conditioned_run_condition_var="bm_install_itself_done"
  export bm_conditioned_run_command="bm_install_itself"
  bm_conditioned_run
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
  export ${bm_export_var}="${bm_export_value}"
}


# bm_export_prepare_value
# (sibiling: bm_export_prepare_var)
# derived from bm_export.
# does the same, but uses
# the result of bm_export_prepare_command
# as value.
#
# * expects:
# bm_export_prepare_var,
# bm_export_prepare_command,
# bm_export_prepare_command_args
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
# bm_export
#
# *(over)writes:
# bm_export_var,
# bm_export_value
#
function bm_export_prepare_value {
  export bm_export_var="${bm_export_prepare_var}"
  export bm_export_value="$(${bm_export_prepare_command} ${bm_export_prepare_command_args})"
  bm_export
}


# bm_export_prepare_var
# (sibiling: bm_export_prepare_value)
# derived from bm_export.
# but, instead of setting a var with
# the value stored in bm_export_var,
# uses the value from the result of
# a command.
#
# * expects:
# bm_export_prepare_value,
# bm_export_prepare_command,
# bm_export_prepare_command_args
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
# bm_export
#
# *(over)writes:
# bm_export_var,
# bm_export_value
#
function bm_export_prepare_var {
  export bm_export_var="$(${bm_export_prepare_command} ${bm_export_prepare_command_args})"
  export bm_export_value="${bm_export_prepare_value}"
  bm_export
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
# bm_echo_command contents
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
# bm_export
#
# *(over)writes:
# bm_export_var,
# bm_export_value,
# bm_resolve_var
#
function bm_fallback {
  export bm_export_var=${bm_fallback_var}
  export bm_export_value=${bm_fallback_to}
  export bm_resolve_var="bm_fallback_var"
  test -z "$(bm_resolve)" && bm_export
}


# bm_fallback_echo_command
#
# * expects:
# bm_echo_command,
#
# * fallbacks:
# bm_echo_command="echo -n"
#
# * becomes interactive:
#
# * requires
#
# *(over)writes:
# bm_fallback_var,
# bm_fallback_to
#
function bm_fallback_echo_command {
  export bm_fallback_var="bm_echo_command"
  export bm_fallback_to="echo -n"
  bm_fallback
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
# bm_export
#
# *(over)writes:
# bm_export_var,
# bm_export_value,
# bm_resolve_var
#
# function: bm_assign
function bm_assign {
  export bm_export_var="${bm_assign_var}"
  export bm_resolve_var="bm_assign_value"
  export bm_export_value="$(bm_resolve)"
  bm_export
}


# bm_conditioned_run
# runs a command if a condition var
# is set.
#
# * expects:
# bm_conditioned_run_condition_var,
# bm_conditioned_run_command,
#
# * becomes interactive:
#
# * requires
# bm_resolve,
# bm_conditioned_run_command contents
#
# *(over)writes:
# bm_resolve_var,
#
function bm_conditioned_run {
  export bm_resolve_var="bm_conditioned_run_condition_var"
  test "$(bm_resolve)" && ${bm_conditioned_run_command}
}


# bm_conditioned_negate_run
# runs a command if a condition var
# is not set.
#
# * expects:
# bm_conditioned_run_condition_var,
# bm_conditioned_run_command,
#
# * becomes interactive:
#
# * requires
# bm_resolve
# bm_conditioned_run_command contents
#
# *(over)writes:
# bm_resolve_var,
#
function bm_conditioned_negative_run {
  export bm_resolve_var="bm_conditioned_run_condition_var"
  test "$(bm_resolve)" && echo -n || ${bm_conditioned_run_command}
}

# alias: bm_conditioned_negatve_run (typo)
function bm_conditioned_negatve_run {
  bm_conditioned_negative_run
}

# bm_function_definition
# gets the definition of a function
# (if there is such a function defined
# on the environment)
#
# * planned changes:
# by now this function depends on "declare -f"
# which returns wrong code (missing ; before the
# last })
#
# * expects:
# bm_function_name
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
# bm_echo_command
#
# *(over)writes:
# bm_function_definition
#
function bm_function_definition {
  bm_function_definition="function $(declare -f ${bm_function_name})"
  ${bm_echo_command} ${bm_function_definition}
}


# bm_function_subshell
# runs the function bm_sudo_function_name
# in a subshell, with a pre-command
#
# * expects:
# bm_function_name
# bm_function_subshell_command
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
# bm_function_definition
#
# *(over)writes:
#
function bm_function_subshell {
  ${bm_function_subshell_command} "$(bm_function_definition); ${bm_function_name}"
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
#
function bm_namespace_add {
  ${bm_echo_command} ${bm_namespace_left}${bm_namespace_right}
}


# bm_export_prepare_with_namespace_add
# exports a var (given by bm_export_prepare_var)
# with the results of calling bm_namespace_add
# 
# * expects:
# bm_export_prepare_var,
# bm_namespace_left,
# bm_namespace_right
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
# bm_export_prepare_value,
#
# *(over)writes:
# bm_export_prepare_command,
# bm_export_prepare_command_args,
#
function bm_export_prepare_with_namespace_add {
  export bm_export_prepare_command="bm_namespace_add"
  export bm_export_prepare_command_args=
  bm_export_prepare_value
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
#
function bm_namespace_rm {
  ${bm_echo_command} ${bm_namespace_left} | sed "s/^${bm_namespace_right}//"
}

# bm_fs_wipe_swp
#
# * expects:
# bm_fs_wipe_swp_sudo_find,
# bm_fs_wipe_swp_sudo_rm
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
# bm_echo_command,
# bm_echo_command (command),
#
# *(over)writes:
# remove files ending in swp in the current tree
# bm_line
#
function bm_fs_wipe_swp {
  ${bm_fs_wipe_swp_sudo_find} find . | grep "\.swp$" | while read bm_line ; do ${bm_fs_wipe_swp_sudo_rm} ${bm_echo_command} rm -rfv "$bm_line" ; done
}


# bm_fs_ln_current_to_time
#
# * expects:
# bm_fs_ln_time,
# bm_fs_ln_path,
# bm_fs_ln_current_pattern,
#
# * fallbacks:
# bm_fs_ln_current_pattern="current"
#
# * becomes interactive:
#
# * requires
# bm_fallback,
# bm_fallback_echo_command,
# bm_ensure_dirname_exists,
#
# *(over)writes:
# bm_fs_ln_current_path,
# bm_fallback_var,
# bm_fallback_to,
# bm_ensure_dirname_path,
#
function bm_fs_ln_current_to_time {
  export bm_fallback_var="bm_fs_ln_current_pattern"
  export bm_fallback_to="current"
  bm_fallback
  bm_fallback_echo_command
  export bm_fs_ln_current_path=$(${bm_echo_command} "${bm_fs_ln_path}" | sed "s/${bm_fs_ln_time}/${bm_fs_ln_current_pattern}/")
  export bm_ensure_dirname_path="${bm_fs_ln_current_path}"
  bm_ensure_dirname_exists
  ln -sf  "${bm_fs_ln_path}" "${bm_fs_ln_current_path}"

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
  [[  -f  "${bm_db_dump_file}"   ]] &&   echo "${bm_db_dump_file} exists" || (   ( PGPASSWORD="${bm_db_password}"  pg_dump  -h  ${bm_db_host} -U ${bm_db_user} ${bm_db_name}  )  |  tee  "${bm_db_dump_file}" )     #iffileexists
  echo "Generated (I hope) dump file, if it didn't exist." &> /dev/stderr
  echo "For restoring it (later), export the following var:" &> /dev/stderr
  echo "export bm_db_dump_file='${bm_db_dump_file}'" &> /dev/stderr
}


# function bm_psql_query_command_output
# prints the command that bm_psql_query
# will run. password is not printed.
#
# * expects:
# bm_db_host, bm_db_user, bm_db_name,
# bm_db_query, bm_db_password
#
# * becomes interactive if not given:
#
# * requires:
#
# * (over)writes:
#
function bm_psql_query_command_output_output {
  # output command:
  echo \"$bm_db_query\"  \| psql  -h ${bm_db_host} -U ${bm_db_user} ${bm_db_name} \&\> /dev/stdout  | tee -a "${bm_psql_query_out_file}"
}


# function bm_psql_query
# queries a database
#
# * expects:
# bm_db_host, bm_db_user, bm_db_name,
# bm_db_query, bm_db_password
#
# * becomes interactive if not given:
# bm_db_password
#
# * requires:
# psql
#
# * (over)writes:
# database bm_db_name in psql,
# file bm_psql_query_out_file,
# PGPASSWORD
#
function bm_psql_query {
  # actual command:
  echo "$bm_db_query"  | PGPASSWORD="${bm_db_password}"    psql  -h ${bm_db_host} -U ${bm_db_user} ${bm_db_name} &> /dev/stdout  | tee -a "${bm_psql_query_out_file}"
}


# function bm_psql_apply_dump_command_output
# prits the command issued by
# bm_psql_apply_dump.
#
# * expects:
# bm_db_host, bm_db_user, bm_db_name,
# bm_db_dump_file, bm_db_password
#
# * becomes interactive if not given:
# bm_db_password
#
# * requires:
#
# * (over)writes:
#
function bm_psql_apply_dump_command_output {
  # output command:
  echo psql -h  ${bm_db_host} -U ${bm_db_user} ${bm_db_name} --set ON_ERROR_STOP=off  \<  ${bm_db_dump_file} \&\> /dev/stdout | tee -a "${bm_out_psql_restore}"
}


# function bm_psql_apply_dump_silent
# dumps $bm_db_dump_file into
# bm_db_name
# was created after bm_psql_apply_dump
# was found printing output, when
# sometimes it's not good.
#
# * expects:
# bm_db_host, bm_db_user, bm_db_name,
# bm_db_dump_file (must
# exist), bm_db_password
#
# * becomes interactive if not given:
# bm_db_password
#
# * requires:
# psql
#
# * (over)writes:
# database bm_db_name in psql,
# file bm_out_psql_restore,
# bm_psql_query_out_file
# PGPASSWORD
#
function bm_psql_apply_dump_silent {
  PGPASSWORD="${bm_db_password}"   psql -h  ${bm_db_host} -U ${bm_db_user} ${bm_db_name} --set ON_ERROR_STOP=off  <  "${bm_db_dump_file}" &> /dev/stdout | tee -a "${bm_out_psql_restore}"
}


# function bm_psql_apply_dump
# dumps $bm_db_dump_file into
# bm_db_name, and select all
# tables from it afterwards.
#
# * expects:
# bm_db_query_show_pg_tables,
# bm_out_psql_restore,
#
# * becomes interactive if not given:
#
# * requires:
#   bm_psql_apply_dump_command_output,
#   bm_psql_apply_dump_silent,
#   bm_psql_query_command_output_output,
#   bm_psql_query
#
# * (over)writes:
# bm_db_query,
# bm_psql_query_out_file
#
function bm_psql_apply_dump {
  # output command:
  bm_psql_apply_dump_command_output
  # actual command:
  bm_psql_apply_dump_silent
  # todo: use bm_assign
  export bm_db_query="${bm_db_query_select_all}"
  export bm_db_query="${bm_db_query_show_pg_tables}"
  export bm_psql_query_out_file="${bm_out_psql_restore}"
  # output command:
  bm_psql_query_command_output_output
  # actual command:
  bm_psql_query
}


# function bm_psql_db_reset
# deletes bm_db_name
# and recreates it
#
# * expects:
# bm_db_name
#
# * becomes interactive if not given:
#
# * requires:
# dropdb,
# create db
#
# * (over)writes:
# database bm_db_name in psql
#
function bm_psql_db_reset {
  dropdb    "${bm_db_name}"
  createdb  "${bm_db_name}"
}


# function bm_sudo_psql_db_reset
# deletes bm_db_name
# and recreates it
#
# * expects:
# bm_db_name
#
# * becomes interactive if not given:
#
# * requires:
# sudo,
# su,
# postgres user,
# dropdb,
# create db
#
# * (over)writes:
# database bm_db_name in psql
#
function bm_sudo_psql_db_reset {
  sudo  su -  postgres bash -c "dropdb  ${bm_db_name}"
  sudo  su -  postgres bash -c "createdb  ${bm_db_name}"
}


# function bm_sudo_psql_restore_dump
# dumps $bm_db_dump_file into
# bm_db_name, after resetting it.
#
# * expects:
#
# * becomes interactive if not given:
# bm_db_password
# * requires:
# bm_psql_apply_dump,
# bm_sudo_psql_db_reset
#
# * (over)writes:
# database bm_db_name in psql
#
function bm_sudo_psql_restore_dump {
  bm_sudo_psql_db_reset
  bm_psql_apply_dump

}


# section future:
# TODO: bm_bashement_env_path must be set by any installer of bashement


# section: templates:
# bm_new_function
#
# * planned changes:
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


# end of script


