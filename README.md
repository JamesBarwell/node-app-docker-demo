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

In this example, the `index.js` is the bootstrap that gathers or instantiates external dependencies, then injects them into the `App.js` where the second layer of DI occurs. The bootstrap is kept relatively simple and declarative. Under test, only the bootstrap code needs to be repeated, and the core application is loaded and run as normal.

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
