const jwt = require('jsonwebtoken');

function authMiddleware(req, res, next) {
    
    const authHeader = req.headers['Authorization'];
    const token = authHeader && authHeader.startsWith('Bearer ') 
                  ? authHeader.split(' ')[1] 
                  : null;

    
    if (!token) {
        return res.status(401).json({ message: 'No token provided' });
    }


    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) {
            return res.status(401).json({ message: 'Invalid token' });
        }

       
        req.user = decoded;
        next();
    });
}

module.exports = authMiddleware;
