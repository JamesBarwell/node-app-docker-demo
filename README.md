Node App Docker Demo
---

An example app to demonstrate some concepts and best practices:

* Double dependency-injection pattern.
* Example test approach.
* Use of official node Docker image.
* Docker multi-stage build, or local node_modules
* Use of linter and code coverage.
* Use of Makefile to build and run Docker image.

## Explanation of the core concepts

### Double DI

This pattern allows for a nearly full integration test approach to testing, with great performance, by only mocking the outermost extremities of the application. This means that the testing can occur at an HTTP level, including the webserver, and assertions made against the HTTP responses. This pattern provides a clear separation of what is and what is not under test, and is a pragmatic approach to full integration testing without causing slow down.

In this example, the `index.js` is the bootstrap that gathers or instantiates external dependencies, then injects them into the `App.js` where the second layer of DI occurs. The bootstrap is kept relatively simple and declarative. Under test, only the bootstrap code needs to be repeated, and the app can be fully tested without internal modification or mocks.

### Test approach

The tests are strictly split between the setup and assertion of each test. This means that failing assertions are clear to understand, and new assertions can easily be added.

### Docker image

Using the official Docker image can be an easy way to run the application securely, and stay up to date with the latest platform features and security fixes.

### Multi-stage build or local node_modules

There are two options for how dependencies are included in the project, depending on how you wish to manage depdencies.

The standard way of building is to copy in the node_modules from the host machine. This would be a good approach if you also wish to commit the node_modules into version control along with the rest of the code. This approach can be beneficial for applications, as it means there is no dependency on external package managers to create a build, and allows full audit and control of dependencies just the same as for the rest of the application code. A downside to this approach is that it is not easy to separate the dependencies that are required in production from those only needed in development, which can lead to a bloated container image.

The multi-stage build will pull in dependencies from NPM at build time. It can also be used if there are other packages or build artefacts that need to be created. The benefit of the multi-stage build is that everything apart from the required artefacts are discarded, so the production container image remains 'pure' and uncontaminated by unnecessary files.

### Linter and code coverage

In a weakly-typed language, the linter is essential to help find code quality issues. The code coverage can provide some clues as to areas of the code that may require additional test coverage.

### Makefile

Provides an example of how the container should be built and run.

## Misc

* `npm install` is run with the `--ignore-scripts` flag, which prevents dependencies and their sub-dependencies from running scripts. This removes the most serious attack vector with npm, however it may break dependencies that rely on install scripts to function. Remove this flag at your own peril.
