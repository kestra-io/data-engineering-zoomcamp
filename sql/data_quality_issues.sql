SELECT * FROM `kestra-sandbox.zooomcamp.green_tripdata` where lpep_pickup_datetime >= '2021-01-01';

SELECT * FROM `kestra-sandbox.zooomcamp.yellow_tripdata` where tpep_pickup_datetime >= CURRENT_TIMESTAMP();

SELECT
  table_id,
  row_count,
  ROUND(size_bytes / (1024 * 1024), 2) AS size_mb,
  TIMESTAMP_MILLIS(last_modified_time) AS last_modified_timestamp
FROM
  `kestra-sandbox.zoomcamp.__TABLES__`
WHERE
  table_id LIKE 'green_tripdata%' OR table_id LIKE 'yellow_tripdata%';

-- Check the number of rows per month for each taxi type
SELECT
  FORMAT_TIMESTAMP('%Y-%m', tpep_pickup_datetime) AS year_month,
  'yellow' AS taxi_type,
  COUNT(*) AS row_count
FROM
  `kestra-sandbox.zooomcamp.yellow_tripdata`
GROUP BY
  year_month, taxi_type

UNION ALL

SELECT
  FORMAT_TIMESTAMP('%Y-%m', lpep_pickup_datetime) AS year_month,
  'green' AS taxi_type,
  COUNT(*) AS row_count
FROM
  `kestra-sandbox.zooomcamp.green_tripdata`
GROUP BY
  year_month, taxi_type
ORDER BY
  year_month DESC, taxi_type;