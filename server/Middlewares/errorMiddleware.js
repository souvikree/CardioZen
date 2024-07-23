// Error handling middleware
function errorMiddleware(err, req, res, next) {
    console.error(err.stack); // Log the error stack trace

    res.status(err.status || 500).json({
        status: 'error',
        message: err.message || 'Internal Server Error',
    });
}

module.exports = errorMiddleware;
