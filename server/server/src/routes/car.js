const { Router } = require('express');
const router = Router();

const mysqlConnection = require('../database/database');

router.get('/', (req, res) => {
    res.status(200).json("Database is Connected cars");
});

router.get('/cars', (req, res)=>{
    mysqlConnection.query("SELECT * FROM cars;", (error, rows, fields)=>{
        if (!error){
            res.json(rows);
        }else{
            console.log(error);
        }
    })
});

router.get('/cars/:id', (req,res) => {
    const {id} = req.params;
    mysqlConnection.query("SELECT * FROM cars WHERE id = ?;", [id], (error, rows, fields)=> {
        if (!error){
            res.json(rows);
        }else{
            console.log(error);
        }
    });
});

router.post('/cars', (req,res) => {
    const {immatriculation, marque, model, annee, pays, kilometrage, couleur, options, isnew} = req.body;
    console.log(req.body);
    mysqlConnection.query('INSERT INTO cars(immatriculation, marque, model, annee, pays, kilometrage, couleur, options, isnew) VALUES(?,?,?,?,?,?,?,?,?);',
    [immatriculation, marque, model, annee, pays, kilometrage, couleur, options, isnew], (error, rows, fields) => {
        if(!error){
            res.json({id : rows.insertId});
        }else{
            console.log(error);
        }
    });
});

router.put('/cars/:id', (req,res) => {
    const {immatriculation, marque, model, annee, pays, kilometrage, couleur, options, isnew} = req.body;
    const {id} = req.params;
    console.log(req.body);
    mysqlConnection.query('UPDATE cars SET immatriculation = ?, marque = ?, model = ?, annee = ?, pays = ?, kilometrage = ?, couleur = ?, options = ?, isnew = ? WHERE id = ?',
    [immatriculation, marque, model, annee, pays, kilometrage, couleur, options, isnew, id], (error, rows, fields) => {
        if(!error){
            res.json(rows);
        }else{
            console.log(error);
        }
    });
});

router.delete('/cars/:id', (req,res) => {
    const {id} = req.params;
    mysqlConnection.query('DELETE FROM cars WHERE id = ?',
    [id], (error, rows, fields) => {
        if(!error){
            res.json({Status: "Car Deleted"});
        }else{
            console.log(error);
        }
    });
});

module.exports = router;