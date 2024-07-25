const jwt = require('jsonwebtoken');

function authMiddleware(req, res, next) {
    // Extract token from Authorization header
    const authHeader = req.headers['Authorization'];
    const token = authHeader && authHeader.startsWith('Bearer ') 
                  ? authHeader.split(' ')[1] 
                  : null;

    // Check if token is provided
    if (!token) {
        return res.status(401).json({ message: 'No token provided' });
    }

    // Verify token using the secret key
    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) {
            return res.status(401).json({ message: 'Invalid token' });
        }

        // Add user data to the request object
        req.user = decoded;
        next();
    });
}

module.exports = authMiddleware;
