const { Router } = require('express');
const router = Router();

const mysqlConnection = require('../database/database');

router.get('/', (req, res) => {
    res.status(200).json("Database is Connected images");
});

router.get('/images', (req, res)=>{
    mysqlConnection.query("SELECT * FROM cars_images;", (error, rows, fields)=>{
        if (!error){
            res.json(rows);
        }else{
            console.log(error);
        }
    });
});

router.get('/images/:id', (req,res) => {
    const {id} = req.params;
    mysqlConnection.query("SELECT * FROM cars_images WHERE car_id = ?;", [id], (error, rows, fields)=> {
        if (!error){
            res.json(rows);
        }else{
            console.log(error);
        }
    });
});

router.post('/images', (req,res) => {
    const {id, link} = req.body;
    console.log(req.body);
    mysqlConnection.query('INSERT INTO cars_images(car_id, link) VALUES(?,?);',
    [id, link], (error, rows, fields) => {
        if(!error){
            res.json({Status: "Image Added"})
        }else{
            console.log(error);
        }
    });
});

router.put('/images/:id', (req,res) => {
    const {link} = req.body;
    const {id} = req.params;
    console.log(req.body);
    mysqlConnection.query('UPDATE cars_images SET link = ? WHERE car_id = ?',
    [link, id], (error, rows, fields) => {
        if(!error){
            res.json({Status: "Image Updated"})
        }else{
            console.log(error);
        }
    });
});

router.delete('/images/:id', (req,res) => {
    const {id} = req.params;
    mysqlConnection.query('DELETE FROM cars_images WHERE car_id = ?',
    [id], (error, rows, fields) => {
        if(!error){
            res.json({Status: "Image Deleted"})
        }else{
            console.log(error);
        }
    });
});

module.exports = router;