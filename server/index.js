
const express = require('express');
const bodyParser = require('body-parser');
const cookieParser = require("cookie-parser");
const cors = require("cors")
const helmet = require('helmet');
const errorMiddleware = require('./Middlewares/errorMiddleware');
const predictionRoutes = require('./Routes/predictionRoutes');
const authRoutes = require('./Routes/authRoutes');

// const userInputRoutes = require('./Routes/userInputRoutes');


require("./Database/db") 
require("dotenv").config();



const port = process.env.PORT || 8000;

const app = express();

app.use(bodyParser.json());


const corsOptions ={
  origin:'*', 
  credentials:true,            
  optionSuccessStatus:200
}

app.use(cors(corsOptions));
app.use(cookieParser());
app.set('etag', false);
app.use(helmet());

app.use((_req, res, next) => {
 
  res.setHeader('Cache-Control', 'no-store');

  
  next();
});


app.use(express.json()); 

// Use prediction routes
app.use('/api/auth', authRoutes);
app.use('/api/predict', predictionRoutes);
// app.use('/api/userinput', userInputRoutes);
// Error handling middleware
app.use(errorMiddleware);

app.get("/", (_req, res) => {
res.send("server is running");
});







app.listen(port, () => {
    console.log(`App is running on port  ${port}`);

})