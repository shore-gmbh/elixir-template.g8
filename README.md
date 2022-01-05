# Elixir Giter8 Template

The template to be used to generate projects in Elixir at Shore using [Giter8](http://www.foundweekends.org/giter8/)!

This template has a project with just api and database configured

## Setup
You can follow this tutorial [here](http://www.foundweekends.org/giter8/setup.html) to install Giter8 on your machine


### Create the project
Create just typing:
```shell
g8 shore-gmbh/elixir-template.g8
```
- Type the name of the project
- Run locally using the README instruction of the project generated
- Upload to github

### Setup on Kubernetes (WIP)
- Create the database on AWS. [Example PR](https://github.com/shore-gmbh/aws-shore-it/pull/759)
- Create the project on [Sentry](https://sentry.io/organizations/shore-gmbh/projects/)
- Create the secrets on kubernetes cluster (staging and prod) using the `create-secret-example.sh` file as example
- Setup the project on [CircleCI](https://app.circleci.com/projects/project-dashboard/github/shore-gmbh/)
