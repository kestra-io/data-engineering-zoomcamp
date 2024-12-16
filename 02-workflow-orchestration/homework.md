## Module 2 Homework

### Assignment

So far in the course, we processed data for the year 2019 and 2020. Your task is to extend the existing flow to include data for the year 2021.

![img.png](img.png)

![img_1.png](img_1.png)

As a hint, Kestra makes that process really easy:
1. You can leverage the backfill functionality in the [scheduled flow](../flows/07_gcp_taxi_scheduled.yaml) to backfill the data for the year 2021. Just make sure to select the time period for which data exists i.e. from `2021-01-01` to `2021-07-31`. Also, make sure to do the same for both `yellow` and `green` taxi data (select the right service in the `taxi` input).
2. Alternatively, run the flow manually for each of the seven months of 2021 for both `yellow` and `green` taxi data. Challenge for you: find out how to loop over the combination of Year-Month and `taxi`-type using `ForEach` task which triggers the flow for each combination using a `Subflow` task.

### Questions

1) Within the execution for `Yellow` Taxi data for the year `2020` and month `12`: what is the uncompressed file size (i.e. the output file `yellow_tripdata_2020-12.csv` of the `extract` task)?
- 128.3 MB
- 134.5 MB
- 364.7 MB
- 692.6 MB

2) What is the task run state of tasks bq_green_tripdata, bq_green_tmp_table and bq_merge_green when you run the flow with the `taxi` input set to value `yellow`?
- `SUCCESS`
- `FAILED`
- `SKIPPED`
- `CANCELED`

3) How do we deal with table schema in the Google Cloud ingestion pipeline?
- We don't define the schema at all because this is a data lake after all
- We let BigQuery autodetect the schema
- Kestra automatically infers the schema from the extracted data
- We explicitly define the schema in the tasks that create external source tables and final target tables

4) How does Kestra handles backfills in the scheduled flow?
- You need to define backfill properties in the flow configuration
- You have to run CLI commands to backfill the data
- You can run backfills directly from the UI from the Flow Triggers tab by selecting the time period
- Kestra doesn't support backfills

5) Which of the following CRON expressions schedules a flow to run at 09:00 UTC on the first day of every month?
- `0 9 1 * *`
- `0 1 9 * *`
- `0 9 * * *`
- `1 9 * * *`

6) How would you configure the timezone to New York in a Schedule trigger?
- Add a `timezone` property set to `EST` in the `Schedule` trigger configuration  
- Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration
- Add a `timezone` property set to `UTC-5` in the `Schedule` trigger configuration
- Add a `location` property set to `New_York` in the `Schedule` trigger configuration  


```yaml
id: homework
namespace: zoomcamp

inputs:
  - id: first
    type: SELECT
    displayName: 1) Uncompressed file size of yellow_tripdata_2020-12.csv
    description: |
      Within the execution for Yellow Taxi data for the year 2020 and month 12, what is the uncompressed file size (i.e. the output file `yellow_tripdata_2020-12.csv` of the `extract` task)?
    required: true
    values:
      - 128.3 MB
      - 134.5 MB
      - 364.7 MB
      - 692.6 MB

  - id: second
    type: SELECT
    displayName: 2) Task run state of bq_green_tripdata for yellow taxi input
    description: |
      What is the task run state of tasks `bq_green_tripdata`, `bq_green_tmp_table` and `bq_merge_green` when you run the flow with the `taxi` input set to value `yellow`?
    required: true
    values:
      - SUCCESS
      - FAILED
      - SKIPPED
      - CANCELED

  - id: third
    type: SELECT
    displayName: |
      3) How to deal with table schema in the GCP ingestion pipeline?
    description: |
      How do we deal with table schema in the ingestion pipeline to BigQuery?    
    required: true
    values:
      - We don't define the schema at all because this is a data lake after all
      - We let BigQuery autodetect the schema
      - Kestra automatically infers the schema from the extracted data
      - We explicitly define the schema in the tasks that create external source tables and final target tables

  - id: fourth
    type: SELECT
    displayName: |
      4) How does Kestra handles backfills in the scheduled flow?
    description: This question tests your understanding of backfills in Kestra
    required: true
    values:
      - You need to define backfill properties in the flow configuration
      - You have to run CLI commands to backfill the data
      - You can run backfills directly from the UI from the Flow Triggers tab by selecting the time period
      - Kestra doesn't support backfills
  
  - id: fifth
    type: SELECT
    displayName: 5) CRON to run flow at 09:00 UTC on the first day of every month
    description: |
      Which of the following CRON expressions schedules a flow to run at 09:00 UTC on the first day of every month?
    required: true
    values:
      - 0 9 1 * *
      - 0 1 9 * *
      - 0 9 * * *
      - 1 9 * * *
        
  - id: sixth
    type: SELECT
    displayName: |
      6) How to set timezone to New York in a Schedule trigger?
    description: How would you configure the timezone to New York in a `Schedule` trigger?
    required: true
    values:
      - Add a timezone property set to EST in the Schedule trigger configuration  
      - Add a timezone property set to America/New_York in the Schedule trigger configuration
      - Add a timezone property set to UTC-5 in the Schedule trigger configuration
      - Add a location property set to New_York in the Schedule trigger configuration

  - id: email
    type: EMAIL
    displayName: Submit your email address to be featured in the leaderboard
    required: true

tasks:
  - id: submission_to_gsheets
    type: io.kestra.plugin.core.log.Log
    message: homework submission {{ inputs }}
```

App for submitting the homework:
```yaml
id: homework
type: io.kestra.plugin.ee.apps.Execution
displayName: Submit DE Zoomcamp answers
namespace: zoomcamp
flowId: homework
access: PUBLIC
tags:
  - Data Engineering
  - Zoomcamp

layout:
  - on: OPEN
    blocks:
      - type: io.kestra.plugin.ee.apps.core.blocks.Markdown
        content: |
          ## Answer the questions below
          Note that there is only one right annswer for each question.
      - type: io.kestra.plugin.ee.apps.execution.blocks.CreateExecutionForm
      - type: io.kestra.plugin.ee.apps.execution.blocks.CreateExecutionButton
        text: Submit homework

  - on: CREATED
    blocks:
      - type: io.kestra.plugin.ee.apps.core.blocks.Markdown
        content: |
          ### Thanks for submitting your homework!
          We will review your questions shortly. 
          
          In the meantime, join Kestra Slack Community if you have any questions.
      
      - type: io.kestra.plugin.ee.apps.core.blocks.Button
        url: https://kestra.io/slack
        style: DEFAULT
        text: Join the community
```

## Submitting the solutions

* Form for submitting: https://courses.datatalks.club/de-zoomcamp-2025/homework/hw2 - TBD we may prefer creating a form with Kestra Apps if possible so that we can automate the grading process
* Check the link above to see the due date
  
## Solution

Will be provided after the due date.
