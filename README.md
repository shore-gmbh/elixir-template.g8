# Elixir Giter8 Template

The template to be used to generate projects in Elixir at Shore using [Giter8](http://www.foundweekends.org/giter8/)!

This template has a project with just api and database configured

## Setup

You can follow this tutorial [here](http://www.foundweekends.org/giter8/setup.html) to install Giter8 on your machine

### Create the project

Create just typing:

```bash
g8 shore-gmbh/elixir-template.g8
```

- Type the name of the project
- DONE, your project will be created in a path with the same name you defined
- To run locally you can follow the instructions on the README of the project, but basically you need:
    - put the correct key on the environment variable `HEXPM_API_KEY` inside the file `docker-compose.yml`
    - Run that: `docker-compose -f docker/docker-compose.yml up --build`
    - Try to access: [http://localhost:4000/health](http://localhost:4000/health)
    - 🚀

After that, upload your new project to a [new repository on github](https://github.com/organizations/shore-gmbh/repositories/new)
