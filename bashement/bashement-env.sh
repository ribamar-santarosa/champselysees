#!/usr/bin/env bash

# function: bm_source_newest_env
export bm_bashement_env_raw_url=
export bm_bashement_env_path=

# function: bm_install_itself
export bm_bashement_raw_url="https://raw.githubusercontent.com/ribamar-santarosa/champselysees/master/bashement/bashement.sh"
export bm_bashement_path="/tmp/bashement.sh"

# function: bm_sudo_psql_restore_dump
export bm_db_name=bm_database
export bm_db_user=$(whoami)
export bm_db_host=$(hostname)
export bm_db_password=

# function: bm_git_clone_and_pull
export bm_repo_url=
export bm_repo_dir=

# function: bm_champselysees_install
export bm_champselysees_repo_dir="${HOME}/.champselysees"
export bm_champselysees_repo_url="https://github.com/ribamar-santarosa/champselysees.git"

# function: bm_ensure_dirname_exists
export bm_ensure_dirname_path=

#  function: bm_wget_download
export bm_wget_url=
export bm_wget_output_path="-"
