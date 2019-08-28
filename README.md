Node App Sample
---

An example app to demonstrate some concepts and best practices:

* Double dependency-injection pattern.
* Example test approach.
* Use of official node Docker image.
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

### Linter and code coverage

In a weakly-typed language, the linter is essential to help find code quality issues. The code coverage can provide some clues as to areas of the code that may require additional test coverage.

### Makefile

Provides an example of how the container should be built and run.
