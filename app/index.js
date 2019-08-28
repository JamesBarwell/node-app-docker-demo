const ApiSource = require('./src/source/api');

const apiSource = ApiSource();

const App = require('./src/App')(
    apiSource,
);

const httpPort = 8080;
App.listen(httpPort, () => {
    console.log(`http.listen: ${httpPort}`);
});
