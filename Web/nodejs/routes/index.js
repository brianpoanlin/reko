var express = require('express');
var router = express.Router();
var MongoClient = require('mongodb').MongoClient;
var fs = require('fs');

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
                    collection.removeMany(({"user": "poppro"}));
                    collection.removeMany(({"user": "brian"}));

                    collection.insertOne({"user": "poppro",
                        "pass": "reko",
                        cards:
                         [
                             {
                                 type: 'OT',
                                 elements: ['Links', 'Github - www.github.com/poppro', 'Personal site - www.poppro.net'],
                                 id: 0
                             },
                             {
                                 type: 'CW',
                                 elements: ['EECS 280 - University of Michigan'],
                                 id: 1
                             },
                             {
                                 type: 'VL',
                                 elements: ['BBBS', 'Sept. 2015 - March 2017', 'Mentor'],
                                 id: 2
                             },
                             {
                                 type: 'AW',
                                 elements: ['MHacks Best Financial Hack - Sept. 2017'],
                                 id: 3
                             },
                             {
                                 type: 'SK',
                                 elements: ['Javascript', 'C++', 'Java', 'Backend', 'Webservice'],
                                 id: 4
                             },
                             {
                                 type: 'WE',
                                 elements: ['Software Engineer','Facebook', 'Present - Future','I worked as a software engineer at Facebook!'],
                                 id: 5
                             },
                             {
                                 type: 'ED',
                                 elements: ['University of Michigan', 'Computer Science', 'April, 2022', '4.0'],
                                 id: 6
                             },
                             {
                                 type: 'PI',
                                 elements: ['Hunter Harloff','harloff@umich.edu', '','poppro.net'],
                                 id: 7
                             }
                         ],
                        "we": 80,
                        "ed": 80,
                        "sk": 80,
                        "aw": 80,
                        "vl": 80,
                        "cw": 80,
                        "ot": 80
                    });
                    let obj = JSON.parse(fs.readFileSync(__dirname + '/data.json', 'utf8'));
                    collection.insertOne(obj);
                } else {
                    console.log(err);
                }
            });
            client.close();
        } else {
            console.log(err);
        }
    });

});

module.exports = router;
