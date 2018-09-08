var express = require('express');
var router = express.Router();
var MongoClient = require('mongodb').MongoClient;

var uri = "mongodb+srv://poppro:reko123@reko-no8a0.gcp.mongodb.net/";

/* GET home page. */
router.get('/', function(req, res, next) {
    res.render('index', {});

    MongoClient.connect(uri, function(err, client) {
        if(!err) {
            const db = client.db('reko');
            // List all the available databases
            db.collection("users", function(err, collection){
                if(!err) {
                    collection.findOne({"user": "poppro"}, function(err, item) {
                        console.log(item);
                    });
                    /*
                    collection.insertOne({"user": "poppro",
                        "pass": "reko",
                     cards:
                     { type: 'WE',
                     title: 'Software Engineer',
                     company: 'Facebook',
                     from: 'Present',
                     to: 'Future',
                     desc: 'I worked as a software engineer at Facebook!' } }});
                    collection.insertOne({"user": "brian",
                        "pass": "reko"});
                    console.log(collection.collectionName);*/

                } else {
                    console.log(err);
                }
            });
        } else {
            console.log(err);
        }
    });

});

module.exports = router;
