#!/usr/bin/env bash

# globals:

export bm_time=$(date +"%Y.%m.%d_%H:%M:%S")  #  timestamp
export bm_out_prefix=${bm_time}.bm
export bm_echo_command="echo -n"


# function: bm_source_newest_env, bm_source_env
export bm_bashement_env_raw_url=
export bm_bashement_env_path=

# function: bm_install_itself
export bm_bashement_raw_url="https://raw.githubusercontent.com/ribamar-santarosa/champselysees/master/bashement/bashement.sh"
export bm_bashement_path="/tmp/bashement.sh"

# function: bm_psql_*
export bm_db_name=bm_database
export bm_db_user=$(whoami)
export bm_db_host=$(hostname)
export bm_db_password=
export bm_psql_out_prefix=user_${bm_db_user}.db_${bm_db_name}.host_${bm_db_host}.${bm_out_prefix}
export bm_db_dump_file=pg_dump.${bm_psql_out_prefix}
export bm_out_psql_query=out.query.${bm_psql_out_prefix}
export bm_out_psql_restore=out.psql.restore.pg_dump.${bm_psql_out_prefix}
export bm_out_psql_restore_query=out.psql.restore.query.${bm_psql_out_prefix}
export bm_out_pg_restore_query=out.pg_restore.query.${bm_psql_out_prefix}

# function: bm_psql_query
export bm_db_query=
export bm_db_query_tablename=
export bm_psql_query_out_file="out.psql.query.${bm_psql_out_prefix}"

# valid assigments for: bm_db_query
export bm_db_query_select_all="select * from ${bm_db_tablename};"
export bm_db_query_show_pg_tables="select tablename from pg_tables; "



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

# function: bm_export
export bm_export_var=
export bm_export_value=

# function: bm_resolve
export bm_resolve_var=

# function: bm_fallback
export bm_fallback_var=
export bm_fallback_to=

# function: bm_assign
export bm_assign_var=
export bm_assign_to=

# function: bm_function_*
export bm_function_name=

# function: bm_function_subshell
export bm_function_subshell_command="bash -c"

# function: bm_namespace_*
export bm_namespace_left=
export bm_namespace_right=

# function: bm_fs_wipe_swp
export bm_fs_wipe_swp_sudo_find=
export bm_fs_wipe_swp_sudo_rm=

# end of environment
