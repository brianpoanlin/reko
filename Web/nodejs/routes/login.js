var express = require('express');
var router = express.Router();
var btoa = require('btoa');
var JSON = require('JSON');
var request = require('request');

/* GET home page. */
router.get('/', function(req, res, next) {
    res.render('login', {failed: false});
});

router.post('/', function(req, res, next) {
    let user = btoa(req.body.user+':'+req.body.pass);
});

module.exports = router;
