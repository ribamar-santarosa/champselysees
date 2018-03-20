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


# TODO: bad name
# bm_set_git_branch_backup
# TODO: bad name
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
# TODO: untested
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


# bm_git_backup
# backups the current branch
#
# * planned changes:
# bm_list_assign is used but buggy.
#
# * expects:
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
# bm_set_git_branch_backup
#
# *(over)writes:
# bm_list_assign_vars,
# bm_list_assign_values,
# bm_git_branch_a,
# bm_git_branch_b
# bm_git_reset_and_hard,
# bm_git_reset_at_head
#
function bm_git_backup {
  bm_set_git_branch_backup
  export bm_list_assign_vars="bm_git_current_branch bm_git_branch_backup"
# TODO: other_vars => to_vars
  export bm_list_assign_other_vars="bm_git_branch_a bm_git_branch_b bm_git_reset_and_hard bm_git_reset_at_head"
  bm_list_assign
  bm_git_update_branch
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

# bm_install_bashement
# the basic case for downloading this script and
# it running. it's mostly supposed to be copied
# and pasted to other scripts.
# recommended way: set only bm_bashement_dir,
# and call this function
# TODO: untested after bug fix
#
# * expects:
# bm_bashement_dir,
# bm_bashement_raw_url,
# bm_bashement_path,
# bm_bashement_env_raw_url,
# bm_bashement_env_path
#
# * fallbacks:
# bm_bashement_dir="/tmp/"
# bm_bashement_raw_url="https://raw.githubusercontent.com/ribamar-santarosa/champselysees/master/bashement/bashement.sh"
# bm_bashement_path="${bm_bashement_dir}/bashement.sh"
# bm_bashement_env_raw_url="https://raw.githubusercontent.com/ribamar-santarosa/champselysees/master/bashement/bashement-env.sh"
# bm_bashement_env_path="${bm_bashement_dir}/bashement-env.sh"
#
#
# * becomes interactive:
#
# * requires
# bm_source_newest_env,
# bm_install_itself,
# bm_source_env
#
# *(over)writes:
# bm_bashement_dir_old,
# bm_bashement_raw_url_old,
# bm_bashement_path_old,
# bm_bashement_env_raw_url_old,
# bm_bashement_env_path_old,
#
function bm_install_bashement {
  # fallbacks if vars are not set:
  test  -z "${bm_bashement_dir}"     && export bm_bashement_dir="/tmp/"
  mkdir -p "${bm_bashement_dir}"
  test  -z "${bm_bashement_raw_url}" && export bm_bashement_raw_url="https://raw.githubusercontent.com/ribamar-santarosa/champselysees/master/bashement/bashement.sh"
  test  -z "${bm_bashement_path}"    && export bm_bashement_path="${bm_bashement_dir}bashement.sh"
  test  -z "${bm_bashement_env_raw_url}" && export bm_bashement_env_raw_url="https://raw.githubusercontent.com/ribamar-santarosa/champselysees/master/bashement/bashement-env.sh"
  test -z "${bm_bashement_env_path}"     && export bm_bashement_env_path="${bm_bashement_dir}bashement-env.sh"

  # store them, because they may get overwritten by bm_source_newest_env
  export bm_bashement_dir_old="${bm_bashement_dir}"
  export bm_bashement_raw_url_old="${bm_bashement_raw_url}"
  export bm_bashement_path_old="${bm_bashement_path}"
  export bm_bashement_env_raw_url_old="${bm_bashement_env_raw_url}"
  export bm_bashement_env_path_old="${bm_bashement_env_path}"

  # download this script
  wget -q --no-cache ${bm_bashement_raw_url} --output-document "${bm_bashement_path}"
  . "${bm_bashement_path}"

  # download the newest suggested env file
  bm_source_newest_env

  # restore them, because they may get overwritten by bm_source_newest_env
  export bm_bashement_dir="${bm_bashement_dir_old}"
  export bm_bashement_raw_url="${bm_bashement_raw_url_old}"
  export bm_bashement_path="${bm_bashement_path_old}"
  export bm_bashement_env_raw_url="${bm_bashement_env_raw_url_old}"
  export bm_bashement_env_path="${bm_bashement_env_path_old}"

  # this part is mostly a tutorial on how to do things after
  # installing -- they will redo the steps above (using the
  # bm_ way). Just that bm_source_env is used instead of
  # bm_source_newest_env,  because the latter will always
  # override it. merging a new file with the current one
  # is still a planned task, and it's not so simple.
  bm_fallback_bashement_vars
  bm_install_itself
  bm_source_env
}


# bm_fallback_bashement_vars
#
# * expects:
# bm_bashement_dir,
# bm_bashement_raw_url,
# bm_bashement_path,
# bm_bashement_env_raw_url,
# bm_bashement_env_path
#
# * fallbacks:
# bm_bashement_dir="/tmp/"
# bm_bashement_raw_url="https://raw.githubusercontent.com/ribamar-santarosa/champselysees/master/bashement/bashement.sh"
# bm_bashement_path="${bm_bashement_dir}/bashement.sh"
# bm_bashement_env_raw_url="https://raw.githubusercontent.com/ribamar-santarosa/champselysees/master/bashement/bashement-env.sh"
# bm_bashement_env_path="${bm_bashement_dir}/bashement-env.sh"
#
#
# * becomes interactive:
#
# * requires
#
# *(over)writes:
#
function bm_fallback_bashement_vars {
  test  -z "${bm_bashement_dir}"     && export bm_bashement_dir="/tmp/"
  mkdir -p "${bm_bashement_dir}"
  test  -z "${bm_bashement_raw_url}" && export bm_bashement_raw_url="https://raw.githubusercontent.com/ribamar-santarosa/champselysees/master/bashement/bashement.sh"
  test  -z "${bm_bashement_path}"    && export bm_bashement_path="${bm_bashement_dir}/bashement.sh"
  test  -z "${bm_bashement_env_raw_url}" && export bm_bashement_env_raw_url="https://raw.githubusercontent.com/ribamar-santarosa/champselysees/master/bashement/bashement-env.sh"
  test -z "${bm_bashement_env_path}"     && export bm_bashement_env_path="${bm_bashement_dir}/bashement-env.sh"
  wget -q --no-cache ${bm_bashement_raw_url} --output-document "${bm_bashement_path}"
  . "${bm_bashement_path}"
}


# bm_source_env
# sources the newest version of the
# default env file for this script
# * expects:
# bm_bashement_env_path
# * fallbacks:
#
# bm_bashement_path
# * becomes interactive:
#
# * requires
# bm_fallback_bashement_vars
#
# *(over)writes:
#
function bm_source_env {
  bm_fallback_bashement_vars
  . "${bm_bashement_env_path}"
}


# bm_source_newest_env
# downloads the newest version of the
# default env file for this script
# and sources it
# TODO: missing a function that would
# load only the new vars
# * expects:
# bm_bashement_raw_url,
# bm_bashement_env_path
# * fallbacks:
#
# * becomes interactive:
#
# * requires
#  bm_wget_download
# bm_fallback_bashement_vars
#
# *(over)writes:
# bm_wget_url,
# bm_wget_output_path,
# environment vars set by bm_bashement_env_raw_url
function bm_source_newest_env {
  bm_fallback_bashement_vars
  export bm_wget_url="${bm_bashement_env_raw_url}"
  export bm_wget_output_path="${bm_bashement_env_path}"
  bm_wget_download
  . "${bm_bashement_env_path}"
}


# bm_install_itself
# downloads the newest version of this script,
# sources it.
#
# * expects:
# bm_bashement_raw_url,
# bm_bashement_path
#
# * becomes interactive:
#
# * requires
#  bm_wget_download,
# bm_fallback_bashement_vars
#
# *(over)writes:
# bm_wget_url,
# bm_wget_output_path,
# bm_install_itself_done
#
function bm_install_itself {
  bm_fallback_bashement_vars
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
#
# * expects:
#
# * becomes interactive:
#
# * requires
#  bm_install_itself,
#  bm_champselysees_install
#
# *(over)writes:
# bm_wget_url,
# bm_wget_output_path
#
function bm_install {
  bm_install_itself
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
# bm_resolve_var,
# bm_echo_command
#
# * fallbacks:
# bm_echo_command=echo -n
#
# * becomes interactive:
#
# * requires
#
# *(over)writes:
# bm_resolve_tmp_var,
#
function bm_resolve {
  test -z "${bm_echo_command}" && export bm_echo_command="echo -n"
  export bm_resolve_tmp_var=$(${bm_echo_command} ${bm_resolve_var})
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
  export bm_export_var="${bm_fallback_var}"
  export bm_export_value="${bm_fallback_to}"
  export bm_resolve_var="${bm_fallback_var}"
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
  export bm_export_var="${bm_assign_to}"
  export bm_resolve_var="${bm_assign_var}"
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
# bm_function_name,
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
# bm_fallback_echo_command,
#
# *(over)writes:
# bm_function_definition
#
function bm_function_definition {
  bm_fallback_echo_command
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
# bm_namespace_left,
# bm_namespace_right,
# bm_fallback_echo_command
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
#   bm_fallback_echo_command
#
# *(over)writes:
#
function bm_namespace_add {
  bm_fallback_echo_command
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
# bm_namespace_left
# bm_namespace_right
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
#   bm_fallback_echo_command
#
# *(over)writes:
#
function bm_namespace_rm {
  bm_fallback_echo_command
  ${bm_echo_command} ${bm_namespace_left} | sed "s/^${bm_namespace_right}//"
}


# bm_export_prepare_with_namespace_rm
# exports a var (given by bm_export_prepare_var)
# with the results of calling bm_namespace_rm
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
function bm_export_prepare_with_namespace_rm {
  export bm_export_prepare_command="bm_namespace_rm"
  export bm_export_prepare_command_args=
  bm_export_prepare_value
}


# bm_list_shift
# shift an element from a list (ie,
# pops the first element)
#
# * planned changes:
#
# * expects:
# bm_list,
# bm_list_separator,
#
# * fallbacks:
# bm_list_separator=" "
#
# * becomes interactive:
#
# * requires
# bm_fallback,
# bm_namespace_rm,
# bm_resolve
#
# *(over)writes:
# bm_list,
# bm_list_first,
# bm_fallback_var,
# bm_fallback_to,
# bm_namespace_left,
# bm_namespace_right
#
function bm_list_shift {
  export bm_fallback_var="bm_list_separator"
  export bm_fallback_to=" "
  bm_fallback
  for bm_list_first in $bm_list ; do
    break
  done
  export bm_export_prepare_var="bm_list"
  export bm_namespace_left="$bm_list"
  export bm_namespace_right="${bm_list_first}"
  bm_export_prepare_with_namespace_rm
  export bm_export_prepare_var="bm_list"
  export bm_namespace_left="$bm_list"
  export bm_namespace_right="${bm_list_separator}"
  bm_export_prepare_with_namespace_rm
  export bm_resolve_var="bm_list_first"
  bm_resolve
}


# bm_export_prepare_with_list_shift
# exports a var (given by bm_export_prepare_var)
# with the results of calling bm_list_shift
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
function bm_export_prepare_with_list_shift {
  export bm_export_prepare_command="bm_list_shift"
  export bm_export_prepare_command_args=
  bm_export_prepare_value
}


# bm_list_export
# exports a list of values to
# a list of vars.
#
# * planned changes:
# TODO: untested
#
# * expects:
# bm_list_export_vars,
# bm_list_export_values
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
# bm_export_prepare_with_list_shift
# bm_export
#
# *(over)writes:
# bm_list,
# bm_list_export_var,
# bm_export_prepare_var,
# bm_list_export_value,
# bm_export_var,
# bm_export_value,
#
function bm_list_export {
  export bm_list="${bm_list_export_values}"
  for bm_list_export_var in ${bm_list_export_vars} ; do
    # stores corresponding value in bm_list_export_value
    export bm_export_prepare_var="bm_list_export_value"
    bm_export_prepare_with_list_shift
    export bm_export_var="${bm_list_export_var}"
    export bm_export_value="${bm_list_export_value}"
    bm_export
  done
}


# bm_list_assign
# assigns each of the vars in a list
# to each of the vars in
# another list.
#
# * planned changes:
# TODO: currently bugged
#
# * expects:
# bm_list_assign_vars,
# bm_list_assign_other_vars
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
# bm_export_prepare_with_list_shift,
# bm_assign
#
# *(over)writes:
# bm_list
# bm_list_assign_var,
# bm_list_assign_to,
# bm_assign_var,
# bm_assign_to,
# bm_export_prepare_var,
#
function bm_list_assign {
  export bm_list="${bm_list_assign_other_vars}"
  for bm_list_assign_var in ${bm_list_assign_vars} ; do
    # stores corresponding var name in in bm_list_assign_to
    export bm_export_prepare_var="bm_list_assign_to"
    bm_export_prepare_with_list_shift
    export bm_assign_var="${bm_list_assign_var}"
    export bm_assign_to="${bm_list_assign_to}"
    bm_assign
  done
}


# bm_operate_binary
#
# * planned changes:
#
# * expects:
# bm_operate_var,
# bm_operate_operation,
# bm_operate_operand,
# bm_operate_command,
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
# bm_export_prepare_value
#
# *(over)writes:
# bm_resolve_var,
# bm_export_prepare_var,
# bm_export_prepare_command,
# bm_export_prepare_command_args,
#
function bm_operate_binary {
  export bm_resolve_var="${bm_operate_var}"
  export bm_export_prepare_var="${bm_operate_var}"
  export bm_export_prepare_command="${bm_operate_command} $(bm_resolve) ${bm_operate_operation} ${bm_operate_operand}"
  export bm_export_prepare_command_args=
  bm_export_prepare_value
}


# bm_int_inc
#
# * planned changes:
#
# * expects:
# bm_int_var
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
# bm_operate_binary
#
# *(over)writes:
# bm_resolve_var,
# bm_export_prepare_var,
# bm_export_prepare_command,
# bm_export_prepare_command_args,
#
function bm_int_inc {
  export bm_operate_var="${bm_int_var}"
  export bm_operate_operation="+"
  export bm_operate_operand="1"
  export bm_operate_command="expr "
  bm_operate_binary
}


# bm_int_dec
#
# * planned changes:
#
# * expects:
# bm_int_var
#
# * fallbacks:
#
# * becomes interactive:
#
# * requires
# bm_operate_binary
#
# *(over)writes:
# bm_resolve_var,
# bm_export_prepare_var,
# bm_export_prepare_command,
# bm_export_prepare_command_args,
#
function bm_int_dec {
  export bm_operate_var="${bm_int_var}"
  export bm_operate_operation="-"
  export bm_operate_operand="1"
  export bm_operate_command="expr "
  bm_operate_binary
}


# bm_fs_wipe_swp
#
# * expects:
# bm_fs_wipe_swp_sudo_find,
# bm_fs_wipe_swp_sudo_rm,
# bm_fallback_echo_command
#
# * fallbacks:
# bm_fallback_echo_command
#
# * becomes interactive:
#
# * requires
#
# *(over)writes:
# remove files ending in swp in the current tree
# bm_line
#
function bm_fs_wipe_swp {
  bm_fallback_echo_command
  ${bm_fs_wipe_swp_sudo_find} find . | grep "\.swp$" | while read bm_line ; do ${bm_fs_wipe_swp_sudo_rm} ${bm_echo_command_dry_run} rm -rfv "$bm_line" ; done
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


function bm_derive_var_debug_format {
  bm_fallback_echo_command
}


function bm_derive_var_debug_format {
  bm_fallback_echo_command
}

function bm_fs_write_pid_file {
  echo $$ > /tmp/bm_pid
}


function bm_future_git_push_force_current_branch {
  # TODO; option to backup the remote branch
  git push -u origin :$(git rev-parse --abbrev-ref HEAD) --tags ; git push  origin $(git rev-parse --abbrev-ref HEAD) --tags #gitforcepushgitpushforce
}

function bm_future_git_log_oneline {
  git log --oneline
}


function bm_future_git_echo_current_branch {
  git rev-parse --abbrev-ref HEAD
}

function bm_future_git_abort_all {
  git merge --abort ; git am --abort ;  git cherry-pick --abort ; git rebase --abort
}

function bm_future_git_reset_hard_origin {
  git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)
}

# bm_future_git_checkout checkouts
# a branch, even in the case
# of multiple remotes
# overwrites:
# bm_git_branch_checkout
function bm_future_git_checkout {
   test -z "${bm_git_branch_checkout}" && export bm_git_branch_checkout="$1"
   git checkout -b ${bm_git_branch_checkout}  origin/${bm_git_branch_checkout}
}


# bm_future_git_pull_current_branch
#  TODO: untested
# pulls the current branch
# overwrites:
# bm_git_branch_command,
# bm_git_branch_a,
# bm_git_branch_command_include
function bm_future_git_pull_current_branch {
   export bm_git_branch_command="pull"
   export bm_git_branch_a="$(git rev-parse --abbrev-ref HEAD)"
   export bm_git_branch_command_include="--tags"
   git ${bm_git_branch_command} origin ${bm_git_branch_a} || git ${bm_git_branch_command} origin -u ${bm_git_branch_a}

}


# bm_future_git_push_current_branch
#  TODO: untested
# pulls the current branch
# overwrites:
# bm_git_branch_command,
# bm_git_branch_a,
# bm_git_branch_command_include
function bm_future_git_push_current_branch {
   export bm_git_branch_command="push"
   export bm_git_branch_a="$(git rev-parse --abbrev-ref HEAD)"
   export bm_git_branch_command_include="--tags"
   git ${bm_git_branch_command} -u origin ${bm_git_branch_a}
}


# while  bm_git_update_branch is not properly tested,
# this function can be used.
# expects:
# feature_branch (the name of the
# branch to be created or updated)
# mainstream_branch (the last branch
# to be merged; the branch to serve
# as of base to the feature_branch)
# after_fork_reset_at_head (if set
# the feature branch will be reset
# to the head given by this hash)
#
#
# examples:
# 
function bm_future_git_create_feature_branch {
  echo "bm_future_git_create_feature_branch{"
  export current_branch=$(git rev-parse --abbrev-ref HEAD)

  # branch_b will be a fork of branch_a:
  # [[ "$last_feature_branch" == "" ]] &&   last_feature_branch="${mainstream_branch}"
  # export  branch_a=${last_feature_branch}
  export  branch_a=${mainstream_branch}
  # branch_b=merge_before_new_divergence
  export  branch_b=${feature_branch}
  # after_fork_reset_at_head=44cd1b6
  export  after_fork_reset_at_head=
  export  after_fork_reset_and_hard="--hard"


  # fork branch_a (last_feature_branch) into branch_b (feature_branch)  and reset to ${after_fork_reset_at_head}
  git checkout ${branch_a} ; git checkout ${branch_b}  ||  git checkout -b ${branch_b} #gitforkaintob

  [[ "$after_fork_reset_at_head" != "" ]] &&   git reset ${after_fork_reset_and_hard} "${after_fork_reset_at_head}"

  # cleanup
  git checkout ${current_branch}
  echo git branch -a \| grep "${feature_branch}"
  git branch -a | grep "${feature_branch}"
  echo "}bm_future_git_create_feature_branch"

}

# while bm_git_backup is still buggy,
# this function can be used
function bm_future_git_backup {
  cb=$(git rev-parse --abbrev-ref HEAD) ; git checkout  -b bk-$(date +"%Y.%m.%d_%H.%M.%S")-$cb ; git checkout $cb
}

# bm_future_git_list_commits matching
# a pattern.
# expects pick_commits_branch (the branch
# history to look for commits)
# pick_commits_message_matching (a commit
# will be listed if its message or hash
# matches this egrep pattern)
# pick_commits_stop_at (the search will stop
# at the commit having the message or hash
# matching this pattern).
# examples:
#   export pick_commits_branch=${experimental_branch}
#   export pick_commits_message_matching=${jira_issue}
#   export  pick_commits_message_matching="cleanup"
#   export  pick_commits_message_matching="password empty or nil|MailboxIns:"
#   export  pick_commits_stop_at="1588912" #TODO #WIP< unset? then HEAD of current branch
#   export  pick_commits_stop_at="divergence separator."
function bm_future_git_list_commits {
  echo "bm_future_git_list_commits{"

  export  outfile_prefix=list_commits.${bm_time}
  export  outfile_base=out.outfile_base.${outfile_prefix}


  echo "pick_commits_stop_full_output{"
  git_command=log
  export outfile_command_prefix=git.${git_command}.${outfile_prefix}
  export outfile=out.pick_commits_stop_full_output.${outfile_command_prefix}

  # this file is important for the script. make it  "outfile_base":
  ln -sf "${outfile}" "${outfile_base}"

  git log --oneline ${experimental_branch}  | sed "/${pick_commits_stop_at}/q"    | tac   | tee "${outfile}" #pick_commits_stop_full_output

  echo "check the list of all involved commits, including the stop_at commit, with their corresponding messages:"
  cat "${outfile}"
  echo "}pick_commits_stop_full_output"

  echo "pick_commits_stop{"

  export git_command=
  export  outfile_command_prefix=cat.outfile_base.${outfile_prefix}
  export  outfile=out.pick_commits_stop.${outfile_command_prefix}

  export  pick_commits_stop=$(cat "${outfile_base}"   | head -1   | cut -f 1 -d " " | xargs echo   ) ; echo ${pick_commits_stop} | tee "${outfile}" #pick_commits_stop

  echo "check the stop_at commit, without its corresponding messages:"
  cat "${outfile}"
  echo "}pick_commits_stop"


  echo "}pick_commits_stop"
  echo "pick_commits_list_reversed{"

  export  git_command=
  export  outfile_command_prefix=cat.outfile_base.${outfile_prefix}
  export  outfile=out.pick_commits_list_reversed.${outfile_command_prefix}

  export  pick_commits_list_reversed=$(cat  "${outfile_base}" | tail -n +2  |  egrep "${pick_commits_message_matching}"   |  cut -f 1 -d " " | xargs echo   ) ; echo ${pick_commits_list_reversed}  | tee "${outfile}" #pick_commits_list_reversed

  echo "check the list of commits to be picked (naturally excluding the stop_at commit), without their corresponding messages:"
  cat "${outfile}"
  echo "}pick_commits_list_reversed"

  echo "pick_commits_negative_list{"


  export  git_command=
  export  outfile_command_prefix=cat.outfile_base.${outfile_prefix}
  export  outfile=out.pick_commits_negative_list.${outfile_command_prefix}

  export pick_commits_negative_list=$(cat    "${outfile_base}" | tail -n +2  |  egrep -v "${pick_commits_message_matching}"   | cut -f 1 -d " " | xargs echo   ) ; echo ${pick_commits_negative_list} |  tee "${outfile}"  #pick_commits_negative_list

  echo "check the negative list of commits -- the commits that are before stop, but won't be picked  (naturally excluding the stop_at commit) -- without their corresponding messages:"
  cat "${outfile}"
  echo "}pick_commits_negative_list"
  echo "}bm_future_git_list_commits"
}

# expects:
#  pick_commits_list_reversed,
#  branch_b the destination branch of the cherry-pick'ed  commits)
# show_before_cherry_pick (outputs a git show before
# cherry-pick the branch, set to 1 if desided):
#  export  show_before_cherry_pick=
# export show_before_cherry_pick=1
# overwrites many things.
# git_push_after_every_cherry_pick
function bm_future_git_cherry_pick_listed_commits {

  echo "bm_future_git_cherry_pick_listed_commits{"
  git checkout ${branch_b}  ||  git checkout -b ${branch_b}
  # export commit_list=$(cat "${filename}")
  # export commit_list=${pick_commits_stop}
  # export  commit_list=${pick_commits_negative_list}
  export  commit_list=${pick_commits_list_reversed}
  export  git_command=cherry-pick
  export  outfile_command_prefix=git.${git_command}.${outfile_prefix}
  export  outfile=out.${outfile_command_prefix}
  export  status_var_prefix=status_git_${git_command}_commit
  export  status_var_prefix=status_git_cherry_pick_commit #TODO escaperegex

  echo "commit_list{${commit_list}}commit_list"

  # mv "${outfile}" ~/outs/ || rm "${outfile}"
  for commit in ${commit_list} ; do
    echo "git{${git_command}{${commit}{" ;
    echo "show_before_cherry_pick{${show_before_cherry_pick}{" ;
    [[ ! -z "${show_before_cherry_pick}"  ]] && echo git show ${commit} ;
    [[ ! -z "${show_before_cherry_pick}"  ]] && git show ${commit} ;
    echo "${show_before_cherry_pick}}show_before_cherry_pick" ;
    echo git ${git_command} ${commit} ;
    echo "output{" ;
    git ${git_command} ${commit}  ;
    test "$git_push_after_every_cherry_pick" && bm_future_git_push_current_branch

    export ${status_var_prefix}_${commit}=$?
    echo "}output" ;
    echo "status{${status_var_prefix}_${commit}}status" ;

    echo "}${commit}}${git_command}}git" ;
  done  &>/dev/stdout  | tee -a  "${outfile}"  #noninteractive

  echo analyze if the cherry-pick output had no issues:
  echo vim -p \"\${outfile}\" \#outfilevim
  echo vim -p \"${outfile}\"
  #interactive todo write down PR link
  echo if the output shows successful cherry-picks,
  echo the branch can be pushed with:
  echo git push -u origin $(git rev-parse --abbrev-ref HEAD) --tags
  echo "don't forget, after merge, to update last_feature_branch, if you use multiflow"
  echo "}bm_future_git_cherry_pick_listed_commits"



}

# expects:
# pick_commits_stop=
# pick_commits_list_reversed=
# pick_commits_list_reversed_negative=
# (these vars are set or required by bm_future_git_list_commits
# call that function and you'll have them
# set on your environment)
# temporary_branch=temporary_branch_tmp #this branch will be deleted!
# experimental_branch (the branch under rebase --
# probably the same as pick_commits_branch)
#
function bm_future_git_properrebase_experimental_branch {
  local_debug_command="echo"
  ${local_debug_command} "bm_future_git_properrebase_experimental_branch{"
  test -z "${temporary_branch}" && export temporary_branch=temporary_branch_tmp
  git branch -D ${temporary_branch}

  ${local_debug_command} "it must fork the experimental branch and hard reset to ${pick_commits_stop}~1"
  branch_a=${experimental_branch}
  branch_b=${temporary_branch}
  after_fork_reset_at_head="${pick_commits_stop}~1"
  after_fork_reset_and_hard="--hard"
  current_branch=$(git rev-parse --abbrev-ref HEAD)

  ${local_debug_command} "fork branch_a into branch_b"
  ${local_debug_command} "git checkout ${branch_a} ; git checkout ${branch_b}  ||  git checkout -b ${branch_b}"
  git checkout ${branch_a} ; git checkout ${branch_b}  ||  git checkout -b ${branch_b}

  git_properrebase_tmp_branch_milestone=m0-fork-
  cb=$(git rev-parse --abbrev-ref HEAD) ; git checkout  -b ${git_properrebase_tmp_branch_milestone}bk-$(date +"%Y.%m.%d_%H.%M.%S")-$cb ; git checkout $cb

  [[ "$after_fork_reset_at_head" != "" ]] &&   ${local_debug_command} "git reset ${after_fork_reset_and_hard} ${after_fork_reset_at_head}"
  [[ "$after_fork_reset_at_head" != "" ]] &&   git reset ${after_fork_reset_and_hard} "${after_fork_reset_at_head}"

  git_properrebase_tmp_branch_milestone=m1-reset-
  cb=$(git rev-parse --abbrev-ref HEAD) ; git checkout  -b ${git_properrebase_tmp_branch_milestone}bk-$(date +"%Y.%m.%d_%H.%M.%S")-$cb ; git checkout $cb

  ${local_debug_command} "then it must cherry pick each of  pick_commits_list_reversed=[${pick_commits_list_reversed}]. first show them:"
  git_command=show ; commit_list=${pick_commits_list_reversed} ; outfile_command_prefix=git.${git_command}.${outfile_prefix}
  for commit in ${commit_list} ; do git ${git_command} ${commit} ; export status_git_${git_command}_commit_${commit}=$?  ; done  #interactive

  git_command=cherry-pick ; commit_list=${pick_commits_list_reversed} ; outfile_command_prefix=git.${git_command}.${outfile_prefix}
  for commit in ${commit_list} ; do  git ${git_command} ${commit} &> /dev/stdout  | tee out.${outfile_command_prefix}.commit_${commit} | tee -a  out.${outfile_command_prefix} ; export status_git_cherry_pick_commit_${commit}=$?  ; done #noninteractive

  git_properrebase_tmp_branch_milestone=m2-reversed-
  cb=$(git rev-parse --abbrev-ref HEAD) ; git checkout  -b ${git_properrebase_tmp_branch_milestone}bk-$(date +"%Y.%m.%d_%H.%M.%S")-$cb ; git checkout $cb

  ${local_debug_command} "then it must cherry-pick the  pick_commits_stop=${pick_commits_stop}"
  git_command=show ; commit_list=${pick_commits_stop} ; outfile_command_prefix=git.${git_command}.${outfile_prefix}
  for commit in ${commit_list} ; do git ${git_command} ${commit} ; export status_git_${git_command}_commit_${commit}=$?  ; done  #interactive

  git_command=cherry-pick ; commit_list=${pick_commits_stop} ; outfile_command_prefix=git.${git_command}.${outfile_prefix}
  for commit in ${commit_list} ; do  git ${git_command} ${commit} &> /dev/stdout  | tee out.${outfile_command_prefix}.commit_${commit} | tee -a  out.${outfile_command_prefix} ; export status_git_cherry_pick_commit_${commit}=$?  ; done #noninteractive

  git_properrebase_tmp_branch_milestone=m3-divisor-
  cb=$(git rev-parse --abbrev-ref HEAD) ; git checkout  -b ${git_properrebase_tmp_branch_milestone}bk-$(date +"%Y.%m.%d_%H.%M.%S")-$cb ; git checkout $cb


  ${local_debug_command} "then it must cherry-pick each of the \$pick_commits_list_reversed_negative . note that maybe it's \${pick_commits_list_negative} reversed, I don' t know now right now."


  git_command=show ; commit_list=${pick_commits_list_reversed_negative} ; outfile_command_prefix=git.${git_command}.${outfile_prefix}
  for commit in ${commit_list} ; do git ${git_command} ${commit} ; export status_git_${git_command}_commit_${commit}=$?  ; done  #interactive

  git_command=cherry-pick ; commit_list=${pick_commits_list_reversed_negative} ; outfile_command_prefix=git.${git_command}.${outfile_prefix}
  for commit in ${commit_list} ; do  git ${git_command} ${commit} &> /dev/stdout  | tee out.${outfile_command_prefix}.commit_${commit} | tee -a  out.${outfile_command_prefix} ; export status_git_${git_command}_commit_${commit}=$?  ; done #noninteractive

  git_properrebase_tmp_branch_milestone=m4-final-
  cb=$(git rev-parse --abbrev-ref HEAD) ; git checkout  -b ${git_properrebase_tmp_branch_milestone}bk-$(date +"%Y.%m.%d_%H.%M.%S")-$cb ; git checkout $cb

  ${local_debug_command} "temporary branch is now the way we want the experimental to be."

  branch_to_fork=${temporary_branch}
  branch_being_overwritten=${experimental_branch}
  branch_a=${branch_to_fork}
  branch_b=${branch_being_overwritten}
  git_delete_option="-d"
  git_delete_option="-D"

  ${local_debug_command} "fork branch_a (last_feature_branch) into branch_b (feature_branch):"
  ${local_debug_command} "git checkout ${branch_a} ; git branch ${git_delete_option} ${branch_b}  &&  git checkout -b ${branch_b}"
  git checkout ${branch_a} ; git branch ${git_delete_option} ${branch_b}  &&  git checkout -b ${branch_b}

  git_properrebase_tmp_branch_milestone=m5-success-
  cb=$(git rev-parse --abbrev-ref HEAD) ; git checkout  -b ${git_properrebase_tmp_branch_milestone}bk-$(date +"%Y.%m.%d_%H.%M.%S")-$cb ; git checkout $cb

  ${local_debug_command} "ensure the new experimental branch has changed only the order of commits, but not the final content:"
  git checkout ${experimental_branch}

  git_diff_options=""
  git_current_branch="$(git rev-parse --abbrev-ref HEAD)"
  git_current_origin="origin/${git_current_branch}"
  branch_a=${git_current_branch}
  branch_b=${git_current_origin}
  ${local_debug_command} "git diff ${git_diff_options} ${branch_a}..${branch_b} | wc -l #don't push if not 0:"
  git diff ${git_diff_options} ${branch_a}..${branch_b} | wc -l #don't push if not 0

  ${local_debug_command} "if above is 0, push the new experimental branch:"
  ${local_debug_command} git checkout ${experimental_branch}
  ${local_debug_command} "git push -u origin :$(git rev-parse --abbrev-ref HEAD) --tags ; git push  origin $(git rev-parse --abbrev-ref HEAD) --tags"

  ${local_debug_command} "}bm_future_git_properrebase_experimental_branch"

}



# bm_future_move_commits
# export show_before_cherry_pick=1
# export pick_commits_message_matching=.
# export pick_commits_stop_at="divergence separator."
# expects last_feature_branch or mainstream_branch}
# TODO bad name _git_ missing
function bm_future_move_commits {
  export destination_branch=${feature_branch}
  export pick_commits_branch=${experimental_branch}
  export outfile_list_commits=out.bm_future_git_list_commits
  export outfile_list_commits_cherry_pick=out.bm_future_git_cherry_pick_listed_commits
  export outfile_list_commits_properrebase=out.bm_future_git_properrebase_experimental_branch

  bm_export_git_current_branch
  stack_branch="$bm_git_current_branch"

  bm_export_git_current_branch ; echo $bm_git_current_branch

  bm_future_git_create_feature_branch


  bm_future_git_list_commits
  bm_future_git_list_commits &> "${outfile_list_commits}" # note: | will open a new and prevent variables to be exported. this is why this function is called twice

  export branch_b=${destination_branch}
  bm_future_git_cherry_pick_listed_commits | tee "${outfile_list_commits_cherry_pick}"

  # egrep -C 1 "^output{|^}output" "${outfile_list_commits_cherry_pick}" | egrep -v "^--|^status{.*}status"


  # push feature branch
  # git push -u origin $(git rev-parse --abbrev-ref HEAD) --tags #gitpushcurrentbranch

  git checkout  ${experimental_branch}

  bm_future_git_properrebase_experimental_branch | tee  "${outfile_list_commits_properrebase}"

  # pushforce experimental branch
  # git push -u origin :$(git rev-parse --abbrev-ref HEAD) --tags ; git push  origin $(git rev-parse --abbrev-ref HEAD) --tags #gitforcepushgitpushforce


}




# end of script


