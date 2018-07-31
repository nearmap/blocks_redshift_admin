# https://nearmap.looker.com/dashboards/redshift_model::redshift_admin

- dashboard: redshift_admin
  title: 'Redshift Admin'
  layout: grid
  rows:
    - elements: [running_queries, locks]
      height: 300
    - elements: [table_load_summary, database_consumption]
      height: 300
    - elements: [recent_files_loaded, recent_load_errors]
      height: 300
    - elements: [vacuum_history, vacuum_progress]
      height: 300

  elements:

  - name: running_queries
    title: 'Running Queries'
    type: table
    model: redshift_model
    explore: running_queries
    dimensions: [running_queries.process_id, running_queries.database_name, running_queries.user, running_queries.query_group, running_queries.start_time, running_queries.time_executing, running_queries.sql]
    measures: []
    sorts: [running_queries.time_executing desc]
    show_view_names: false
    show_row_numbers: true
    width: 12
    limit: 200

  - name: locks
    title: 'Table Locks'
    type: table
    model: redshift_model
    explore: locks
    dimensions: [locks.relname, locks.usename, locks.mode, locks.granted, locks.is_pg_backend]
    measures: []
    sorts: []
    show_view_names: true
    show_row_numbers: true
    width: 12
    height: 4
    limit: 500

  - name: table_load_summary
    title: 'Table Load Summary'
    type: table
    model: redshift_model
    explore: redshift_data_loads
    dimensions: [redshift_data_loads.root_bucket, redshift_data_loads.s3_path_clean, redshift_data_loads.file_stem]
    measures: [redshift_data_loads.hours_since_last_load]
    sorts: [redshift_data_loads.root_bucket]
    show_view_names: true
    show_row_numbers: true
    width: 12
    height: 4
    limit: 500

  - name: recent_files_loaded
    title: 'Recent Files Loaded'
    type: table
    model: redshift_model
    explore: redshift_data_loads
    dimensions: [redshift_data_loads.file_name]
    measures: [redshift_data_loads.hours_since_last_load]
    filters:
      redshift_data_loads.load_date: 3 hours
    sorts: [redshift_data_loads.hours_since_last_load]
    show_view_names: true
    show_row_numbers: true
    width: 12
    height: 4
    limit: 500

  - name: recent_load_errors
    title: 'Recent Load Errors'
    type: table
    model: redshift_model
    explore: redshift_etl_errors
    dimensions: [redshift_etl_errors.error_date, redshift_etl_errors.file_name, redshift_etl_errors.column_name,
      redshift_etl_errors.column_data_type, redshift_etl_errors.error_reason]
    filters:
      redshift_etl_errors.error_date: 7 days
    sorts: [redshift_etl_errors.error_date desc]
    show_view_names: true
    width: 12
    height: 4
    limit: 500

  - name: database_consumption
    title: 'Database Consumption'
    type: table
    model: redshift_model
    explore: redshift_db_space
    dimensions: [redshift_db_space.schema, redshift_db_space.table_stem]
    measures: [redshift_db_space.total_rows, redshift_db_space.total_megabytes, redshift_db_space.total_tables]
    sorts: [redshift_db_space.total_megabytes desc]
    show_view_names: true
    show_row_numbers: true
    width: 12
    height: 4
    limit: 500

  - name: vacuum_history
    title: 'Vacuum History'
    type: table
    model: redshift_model
    explore: vacuum_history
    dimensions: [vacuum_history.xid,
                vacuum_history.userid,
                vacuum_history.table_name,
                vacuum_history.status,
                vacuum_history.rows,
                vacuum_history.sortedrows,
                vacuum_history.blocks,
                vacuum_history.max_merge_partitions,
                vacuum_history.eventtime_date,
                vacuum_history.eventtime_time_of_day]
    measures: []
    sorts: [vacuum_history.eventtime desc]
    show_view_names: false
    show_row_numbers: true
    width: 12
    height: 4
    limit: 500

  - name: vacuum_progress
    title: 'Vacuum Progress'
    type: table
    model: redshift_model
    explore: vacuum_progress
    dimensions: [vacuum_progress.table_name, vacuum_progress.status, vacuum_progress.time_remaining_estimate]
    measures: []
    sorts: []
    show_view_names: false
    show_row_numbers: true
    width: 12
    height: 4
    limit: 200
