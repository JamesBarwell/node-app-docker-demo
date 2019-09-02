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

### Double dependency-injection

In this example, most modules export a function, which is invoked by passing the module dependencies. This 'module constructor' function typically returns an object representing the module's public interface. This allows for a simple dependency injection approach to modules, and a simple way of achieving scoping. It is fine to break this rule when dependency management or scoping isn't required - perhaps to return a class or just a simple function.

Typically when trying to test an application there is a trade-off between achieving full integration test coverage versus the poor performance of loading HTTP servers and databases. This often leads to slow tests, or large parts of the application being mocked out and therefore not properly tested.

In this example, the application is constructed by doing two rounds of dependency construction and injection. The first occurs in a bootstrap, and the second in the core application. The idea behind this pattern is that the bootstrap constructs dependencies that will be mocked out under test, whereas the core application's DI will still take place under test. This means that it is possible to mock only the outermost extremities of the application - the inputs and outputs - and to treat the application as a blackbox. In practical terms, this makes it easy and fast to test at the HTTP level, sending fake requests at the real HTTP server, and asserting on the HTTP responses and data sources such as a database adaptor.

In this example, the `index.js` is the bootstrap that gathers or instantiates external dependencies, then injects them into the `app.js` where the second layer of DI occurs. The bootstrap is kept relatively simple and declarative. Under test, only the bootstrap code needs to be repeated, and the core application is loaded and run as normal.

Using this approach, it is possible to quickly build up a good amount of behavioural test coverage of the application, which can often prove more valuable than individual unit tests. (Of course, unit tests could still be used in addition where appropriate.)

### Test approach

The tests are strictly split between the setup and assertion of each test. This means that failing assertions are clear to understand, and new assertions can easily be added.

### Docker image

Using the official Docker image can be an easy way to run the application securely, and stay up to date with the latest platform features and security fixes.


### Multi-stage build or local node_modules

The docker build is carried out using a multi-stage build process. This effectively creates two container environments, where the first container is used as a temporary build environment, and the artefacts of that build are carried into the second container which will become the production artefact.

In a simple node application this may feel a bit over-the-top given that the only artefact required is the `node_modules` directory. But this is useful to demonstrate that a 'pure' production container can be created without any superfluous files, such as the `package.json` metadata files, or dev dependencies. Of course, we are still reliant on the NPM ecosystem and the quality of the dependencies we are pulling into our projects, and it is always worth trying to minimise reliance on these where sensible.

Another option which some prefer is to commit the `node_modules` directory directly into the codebase. This can be a very sensible approach so as to remove any dependency on the internet or NPM servers to run the application or its tooling. It also provides much better control of the dependencies, such as auditing, upgrades and rollback, because it treats dependencies the same as any other code in the application. One downside to this approach is that it is hard to distinguish the dev-dependencies from the prod-dependencies when creating the production container image, so the production image can become more bloated. Some developers will prefer to rely on the `package-lock.json` and to trust that NPM will always be available and won't ever favour this approach.

If you do wish to do this, adjust the `.gitignore` and commit the `node_modules`. Then see the included `Dockerfile-node-modules` alternative Dockerfile.


### Linter and code coverage

The linter will help with code-style enforcement, but more importantly it can discover bugs such as the use of undeclared variables. In a weakly-typed language this static checking is essential to help discover code quality issues.

The code coverage can provide some clues as to areas of the code that may require additional test coverage.

### Makefile

Provides an example of how the container should be built and run.

The commands included here could perhaps remove the need for a proper CI tool in the early stages of a project. When CI is required, the commands can just be called by the CI tool, so the CI configuration does not require any special knowledge of how to build the project other than the name of the command.

## Misc

* `npm install` is run with the `--ignore-scripts` flag, which prevents dependencies and their sub-dependencies from running scripts. This removes the most serious attack vector with npm, however it may break dependencies that rely on install scripts to function. Remove this flag at your own peril.
