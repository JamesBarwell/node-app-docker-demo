module.exports = (apiSource) => {
    async function getIpAddress() {
        const data = await apiSource.fetchIpAddress();
        return data.ip;
    }

    return {
        getIpAddress,
    };
};
