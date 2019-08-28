const http = require('http');

function httpGetJson(uri) {
    return new Promise((resolve, reject) => {
        http.get(uri, {
            headers: {
                Accept: 'application/json',
            },
        }, (res) => {
            let data = '';
            res.on('data', (chunk) => {
                data += chunk;
            });

            res.on('end', () => {
                resolve(data);
            });
        }).on('error', reject);
    });
}

module.exports = () => {
    async function fetchIpAddress() {
        console.log('source.api.fetchIpAddress.start');

        let result;
        try {
            result = await httpGetJson('http://ifconfig.co');
        } catch (err) {
            console.log('Error making HTTP request:', err);
            throw err;
        }

        let jsonResult;
        try {
            jsonResult = JSON.parse(result);
        } catch (err) {
            console.log('Error parsing JSON:', err);
            throw err;
        }

        console.log('source.api.fetchIpAddress.complete');

        return jsonResult;
    }

    return {
        fetchIpAddress,
    };
};
