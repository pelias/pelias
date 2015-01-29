# Submitting Issues

All issues for Pelias are housed in the [pelias/pelias](https://github.com/pelias/pelias) repo. Before opening an issue, be sure to search the repository to see if someone else has asked your question before. If not, go ahead and [open a new issue](https://github.com/pelias/pelias/issues/new).

## Submitting issues around search result quality

It's important to get feedback about the quality of local search results. When it comes to things like address structure, capitalization, and spelling errors, your local knowledge will make it easier for us to understand the problem. When submitting issues be sure to include:
- Where in the world you were searching
- Your search query
- Your expected result
- Your actual result

# Submitting Pull Requests

- Expectations of PRs
- Coding standards? Where are they written down?
- tests

# Project standards overview

Pelias has several miscellaneous standards:

- we use [JSHint](http://jshint.com/docs/) for linting
- we use [TravisCI](https://travis-ci.org/) for continuous integration
- we *love* tests, especially when written with [tape](https://github.com/substack/tape)
- modularity is key. Don't contribute/develop packages that are tightly coupled to another, and make them general
  purpose where possible.

`jshint` and any unit tests in a project will be automatically invoked when you commit to an existing project; make
sure they exit successfully!

# Active contributors

We'll gladly invite active contributors to become members of the [Pelias organization](https://github.com/pelias). New
members will gain direct write permissions, *and with great power comes great responsibility*. To ensure that any new
repositories that you create conform to Pelias standards, we developed [pelias-init](https://github.com/pelias/init), a
simple project generator that will initialize all of the boilerplate needed to get started on a new project.
