var config = require("../config");
var dummy = require("../dummy");
var pgp = require('pg-promise')();

/*
    THIS FILE CREATES AND POPULATE THE DATABASE
 */

function init_db() {

    // Create tables and dummy data
    var db = pgp(config.db.connectionString);

    // Create init tables
    db.one('CREATE TABLE users(name VARCHAR(100) PRIMARY KEY, password VARCHAR(50));')
        .then(function () {
        })
        .catch(function (err) {

            // Insert dummy users
            var users = dummy.users;
            for (var i = 0; i < users.length; i ++) {
                var u = users[i];
                db.one('INSERT INTO users(name, password) values($1, $2)', [u.username, u.password])
                    .then(function () {
                        // success;
                    })
                    .catch(function (err) {
                    });
            }

        });

    db.one('CREATE TABLE products(id INTEGER PRIMARY KEY, name VARCHAR(100) not null, description TEXT not null, price INTEGER, image VARCHAR(500))')
        .then(function () {

        })
        .catch(function (err) {


            // Insert dummy products
            var products = dummy.products;
            for (var i = 0; i < products.length; i ++) {
                var p = products[i];
                db.one('INSERT INTO products(id, name, description, price, image) values($1, $2, $3, $4, $5)', [i, p.name, p.description, p.price, p.image])
                    .then(function () {
                        // success;
                    })
                    .catch(function (err) {
                    });
            }

        });

    db.one('CREATE TABLE purchases(id SERIAL PRIMARY KEY, product_id INTEGER not null, product_name VARCHAR(100) not null, user_name VARCHAR(100), mail VARCHAR(100) not null, address VARCHAR(100) not null, phone VARCHAR(40) not null, ship_date VARCHAR(100) not null, price INTEGER not null)')
        .then(function () {

        })
        .catch(function (err) {
        });


}

module.exports = init_db;