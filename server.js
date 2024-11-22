const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const path = require('path');

const app = express();

// for CORS and JSON parsing
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname)));

// Database connection
// this file is just temporary please change the user and the password when running for the first time
//use the username and password for what you have set up in mysql
const db = mysql.createConnection({
    host: 'localhost',
    user: 'enter user here', 
    password: 'enter passcode here',
    database: 'CS_Student_Graduation_Checker'
});

// check database connection status
db.connect((err) => {
    if (err) {
        console.error('Error connecting to database:', err);
        return;
    }
    console.log('Connected to database');
});

// Search endpoint
app.get('/api/search-courses', (req, res) => {
    const searchTerm = req.query.term.toLowerCase();
    
    // query to get ALL courses first
    const query = `
        SELECT course_code, course_name, credits, category 
        FROM Courses 
        ORDER BY course_code
    `;
    
    console.log('Executing query:', query);
    
    db.query(query, [], (err, results) => {
        if (err) {
            console.error('Database error:', err);
            res.status(500).json({ error: 'Database error' });
            return;
        }
        
        // Filter results in JavaScript for debugging
        const filteredResults = results.filter(course => 
            course.course_code.toLowerCase().includes(searchTerm) ||
            course.course_name.toLowerCase().includes(searchTerm) ||
            course.category.toLowerCase().includes(searchTerm)
        );
        
        // console output to check what is
        console.log('Search term:', searchTerm);
        console.log('Total courses:', results.length);
        console.log('Filtered courses:', filteredResults.length);
        
        res.json(filteredResults);
    });
});

// Start server
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
