# dbt-steampipe

Example of running dbt against [steampipe](https://steampipe.io/).

Steampipe spins up a Postgres database, with a writeable `public` schema so we can re-use the Postgres adapter.

This docker compose environment mounts local AWS and GCP credentials to access the APIs from the container.

## Getting started

1. Build the image: change the plugins list to what you need, in the [docker-compose.override.yml](./docker-compose.override.yml) file

```sh
docker compose build steampipe
```

2. Start steampipe:

```sh
docker compose up
```

3. Install dbt dependencies:

```sh
pip install -r requirements.txt
```

You can query de database through `psql` (password: `steampipe`s):

```sh
psql -h localhost -p 9193 -U steampipe -d steampipe
```

Or open a steampipe query shell:

```sh
docker compose exec steampipe steampipe query
```

## Example

In this example I pull the number of bytes processed by GCP BigQuery jobs and join it to a simple seed to figure out how much they cost.

The model [bq_billable_bytes.sql](steampipe_example/models/example/bq_billable_bytes.sql) uses a steampipe table so you might incur some API call costs if you run it.

### Running the example

1. Update [conf/config.spc](conf/config.spc) with your GCP project

2. Run

    ```sh
    cd steampipe_example
    dbt seed --full-refresh
    dbt run
    ```
