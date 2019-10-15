# Affordable Housing Monitoring

An alpha project for Southwark for monitoring affordable housing in the borough.

More information can be found at https://www.southwark.gov.uk/innovate/collabrative-project/affordable-housing-monitoring

## Setting up the project

Project can either be run locally or via Docker Compose

### Local setup

Requirements: Ruby 2.6.5, [Postgres](https://postgresapp.com/)

```bash
bundle
yarn
rake db:setup
rails s
```

### Docker compose setup

Requirements: [Docker](https://docs.docker.com/docker-for-mac)

```bash
docker-compose up
```

---

In either setup, the server will be running on http://localhost:3000, and the default user is email@example.com with the password of 'password'

## Running the tests

Tests can be run by running `rake`.
