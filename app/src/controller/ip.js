module.exports = (apiRepo) => {
    async function ipAction(req, res, next) {
        try {
            const result = await apiRepo.getIpAddress();
            res.setHeader('Content-Type', 'plain/text');
            res.send(`My IP is: ${result}`);
        } catch (err) {
            next(err);
        }
    }

    return {
        ipAction,
    };
};
