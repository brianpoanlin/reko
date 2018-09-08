var express = require('express');
var router = express.Router();
var MongoClient = require('mongodb').MongoClient;

var uri = "mongodb+srv://poppro:reko123@reko-no8a0.gcp.mongodb.net/";

/* GET home page. */
router.get('/', function(req, res, next) {
    res.render('index', {});

    /*MongoClient.connect(uri, function(err, client) {
        if(!err) {
            const db = client.db('reko');
            // List all the available databases
            //db.createCollection("users", { size: 21474836 } )
            db.collection("users", function(err, collection){
                if(!err) {
                    collection.findOne({"user": "brian", "pass": "reko"}, function(err, item) {
                        console.log(item);
                    });
                    /*collection.insertOne({"user": "poppro",
                        "pass": "reko"});
                    collection.insertOne({"user": "brian",
                        "pass": "reko"});*/
                    /*console.log(collection.collectionName);
                } else {
                    console.log(err);
                }
            });
            db.listCollections(function (err, col) {
              console.log(col);
            })
        } else {
            console.log(err);
        }
    });*/

});

module.exports = router;
