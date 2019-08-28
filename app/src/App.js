const express = require('express');

const ApiRepo = require('./repository/api');
const IpController = require('./controller/ip');

module.exports = (
    apiSource,
) => {
    const apiRepo = ApiRepo(apiSource);
    const ipController = IpController(apiRepo);

    const app = express();

    app.get('/', ipController.ipAction);

    app.use((err, req, res, next) => {
        console.log('app.error', err.toString());

        if (res.headersSent) {
            return next(err);
        }

        res.status(500);
        return res.send('internal server error');
    });

    return app;
};
