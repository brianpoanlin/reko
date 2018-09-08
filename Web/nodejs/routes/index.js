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
                    collection.removeMany(({"user": "poppro"}));
                    collection.removeMany(({"user": "brian"}));

                    collection.insertOne({"user": "poppro",
                        "pass": "reko",
                        cards:
                         [
                             {
                                 type: 'WE',
                                 title: 'Software Engineer',
                                 company: 'Facebook',
                                 from: 'Present',
                                 to: 'Future',
                                 desc: 'I worked as a software engineer at Facebook!',
                                 id: 0
                             },
                             {
                                 type: 'PI',
                                 name: 'Hunter Harloff',
                                 email: 'harloff@umich.edu',
                                 phone: '',
                                 links: ['poppro.net'],
                                 id: 1
                             },
                             {
                                 type: 'SK',
                                 skills: ['Javascript', 'C++', 'Java', 'Backend', 'Webservice'],
                                 id: 2
                             },
                             {
                                 type: 'ED',
                                 school: 'University of Michigan',
                                 degree: 'Computer Science',
                                 month: 'April',
                                 year: '2022',
                                 gpa: '4.0'
                             },
                             {
                                 type: 'AW',
                                 awards: [
                                    {
                                        name: '',
		                                date: ''
                                    }
                                ]
                             },
                             {
                                 type: 'VL',
                                 org: 'BBBS',
                                 from: 'Sept. 2015',
                                 to: 'March 2017',
                                 desc: 'Mentor'
                             },
                             {
                                 type: 'CW',
                                 courses: [
                                    {
                                        name: 'EECS 280',
                                        school: 'University of Michigan'
                                    }
                                 ]
                             }
                         ]
                    });
                    collection.insertOne({"user": "brian",
                        "pass": "reko"});

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
