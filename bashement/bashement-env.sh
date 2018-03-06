#!/usr/bin/env bash

# globals:

export bm_time=$(date +"%Y.%m.%d_%H:%M:%S")  #  timestamp
export bm_out_prefix=${bm_time}.bm


# function: bm_source_newest_env, bm_source_env
export bm_bashement_env_raw_url=
export bm_bashement_env_path=

# function: bm_install_itself
export bm_bashement_raw_url="https://raw.githubusercontent.com/ribamar-santarosa/champselysees/master/bashement/bashement.sh"
export bm_bashement_path="/tmp/bashement.sh"

# function: bm_sudo_psql_*
export bm_db_name=bm_database
export bm_db_user=$(whoami)
export bm_db_host=$(hostname)
export bm_db_password=
export bm_psql_out_prefix=user_${db_user}.db_${db_name}.host_${db_host}.${bm_out_prefix}
export bm_db_dump_file=pg_dump.${bm_psql_out_prefix}
export bm_out_psql_query=out.query.${bm_psql_out_prefix}
export bm_out_psql_restore=out.psql.restore.pg_dump.${bm_psql_out_prefix}
export bm_out_psql_restore_query=out.psql.restore.query.${bm_psql_out_prefix}
export bm_out_pg_restore_query=out.pg_restore.query.${bm_psql_out_prefix}



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

# end of environment
