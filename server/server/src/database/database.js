const mysql = require('mysql');

const mysqlConnection = mysql.createConnection({
    host: "localhost",
    user: 'root',
    password: '',
    database: 'mycarmanager'
});

mysqlConnection.connect(function(error){
    if(error){
        console.log(error);
        return;
    }else{
        console.log('Database is Connected');
    }
});

module.exports = mysqlConnection;