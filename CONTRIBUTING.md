Pelias can't succeed without contributions from community members like you! Contributions come in many different shapes and sizes. In this file we provide guidance around two of the most common types of contributions: opening issues and opening pull requests.

# Community Values 

We ask that you are respectful when contributing to Pelias or engaging with our community. As a community, we appreciate the fact that contributors might be approaching the project from a different perspective and background. We hope that beginners as well as advanced users will be able to use and contribute back to Pelias. We want to encourage contributions and feedback from all over the world, which means that English might not be a contributor's native language, and sometimes we may encounter cultural differences. Contructive disagreements can be essential to moving a project forward, but disrespectful language or behavior will not be tolerated. 

Above all, be patient, be respectful, and be kind!

# Submitting Issues

All issues for Pelias are housed in the [pelias/pelias](https://github.com/pelias/pelias) repo. Before opening an issue, be sure to search the repository to see if someone else has asked your question before. If not, go ahead and [open a new issue](https://github.com/pelias/pelias/issues/new).

## Submitting technical bugs

When submitting bug reports, please be sure to give us as much context as possible so that we can reproduce the error you encountered. Be sure to include:
- System conditons (OS, browser, etc)
- Steps to reproduce
- Expected outcome
- Actual outcome
- Screenshots, if applicable
- Code that exposes the bug, if you have it (such as a failing test or a barebones script)

## Submitting issues around search result quality

It's important to get feedback about the quality of local search results. When it comes to things like address structure, capitalization, and spelling errors, your local knowledge will make it easier for us to understand the problem. When submitting issues be sure to include:
- Where in the world you were searching
- Your search query
- Your expected result
- Your actual result


# Pull Requests Welcome!

## Project standards overview

Pelias has several miscellaneous standards:

- we use [JSHint](http://jshint.com/docs/) for linting
- we use [TravisCI](https://travis-ci.org/) for continuous integration
- we use [Winston](https://www.npmjs.com/package/winston) for logging
- we *love* tests, especially when written with [tape](https://github.com/substack/tape)
- we use [semver](http://semver.org/) for package versioning
- we *loosely* use [JSDoc](http://usejsdoc.org/index.html) for documenting code, as described [here](in_code_documentation_guidelines.md)

`jshint` and any unit tests in a project will be automatically invoked when you commit to an existing project; make
sure they exit successfully!

## Active contributors

We'll gladly invite active contributors to become members of the [Pelias organization](https://github.com/pelias). New
members will gain direct write permissions, *and with great power comes great responsibility*. To ensure that any new
repositories that you create conform to Pelias standards, we developed [pelias-init](https://github.com/pelias/init), a
simple project generator that will initialize all of the boilerplate needed to get started on something new.
