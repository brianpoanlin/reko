let createError = require('http-errors');
let express = require('express');
let path = require('path');
let logger = require('morgan');

let indexRouter = require('./routes/index');
let loginRouter = require('./routes/login');

let app = express();

let MongoClient = require('mongodb').MongoClient;

let uri = "mongodb+srv://poppro:reko123@reko-no8a0.gcp.mongodb.net/";

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, 'public')));

let io = require('socket.io')(2000);

io.sockets.on('connection', function (socket) {
    console.log('Connection');
    let id = socket.id;
   //console.log(io.sockets.connected[id]);

    socket.on('push card', function (data) {
        MongoClient.connect(uri, function(err, client) {
            if(!err) {
                const db = client.db('reko');
                db.collection("users", function(err, collection){
                    if(!err) {
                        collection.findOne({"user": data.user}, function(err, item) {
                            console.log(item.cards[data.card]);
                            socket.broadcast.emit('new_card', {card: item.cards[data.card]});
                        });
                    } else {
                        console.log(err);
                    }
                });
            } else {
                console.log(err);
            }
        });
    }).on('login', function(data) {
        console.log('Logged in: ' + data.user);
        MongoClient.connect(uri, function(err, client) {
            if(!err) {
                const db = client.db('reko');
                db.collection("users", function(err, collection){
                    if(!err) {
                        collection.findOne({"user": data.user}, function(err, item) {
                            socket.emit('card stack', {card: item.cards});
                        });
                    } else {
                        console.log(err);
                    }
                });
            } else {
                console.log(err);
            }
        });
    });
});

app.use('/login', loginRouter);

app.use('/', indexRouter);
app.use('/login', indexRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
