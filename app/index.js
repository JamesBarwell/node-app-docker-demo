const App = require('./src/app');
const ApiSource = require('./src/source/api');

const apiSource = ApiSource();
const app = App(
    apiSource,
);

const httpPort = 8080;
app.listen(httpPort, () => {
    console.log(`http.listen: ${httpPort}`);
});
