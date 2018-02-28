#!/usr/bin/env bash

# function: bm_sudo_psql_restore_dump
export bm_db_name=bm_database
export bm_db_user=$(whoami)
export bm_db_host=$(hostname)
export bm_db_password=
