var express = require('express');
var check_logged = require("./login_check");
var url = require("url");
var db_products = require("../model/products");
var router = express.Router();


/* GET home page. */
router.get('/', function(req, res, next) {

    check_logged(req, res);

    db_products.list()
        .then(function (data) {
            res.render('products', { products: data });
        })
        .catch(function (err) {
            console.log(err);

            res.render('products', { products: [] });
        });
});

router.get('/products/purchased', function(req, res, next) {

    check_logged(req, res);

    db_products.getPurchased(req.session.user_name)
        .then(function (data) {

            console.log(data);
            res.render('bought_products', { products: data });
        })
        .catch(function (err) {
            console.log(err);

            res.render('bought_products', { products: [] });
        });
});

router.get('/products/detail', function(req, res, next) {

    check_logged(req, res);

    var url_params = url.parse(req.url, true).query;

    var product_id = url_params.id;

    db_products.getProduct(product_id)
        .then(function (data) {
            res.render('product_detail', { product: data });
        })
        .catch(function (err) {
            console.log(err);

            res.render('products', { products: [] });
        });
});



router.get('/products/search', function(req, res, next) {

    check_logged(req, res);

    var url_params = url.parse(req.url, true).query;
    var query = url_params.q;

    if (query == undefined) {
        res.render('search', { in_query: "", products: [] });
        return;
    }

    db_products.search(query)
        .then(function (data) {

            res.render('search', { in_query: query, products: data });
        })
        .catch(function (err) {

            console.log(err);

            res.render('search', { in_query: query, products: [] });
        });

});


router.all('/products/buy', function(req, res, next) {

    check_logged(req, res);

    var params = null;
    if (req.method == "GET"){
        params = url.parse(req.url, true).query;
    } else {
        params = req.body;
    }

    var cart = null;

    try {

        if (params.price == undefined){
            throw new Error("Missing parameter 'price'");
        }

        cart = {
            mail: params.mail,
            address: params.address,
            ship_date: params.ship_date,
            phone: params.phone,
            product_id: params.product_id,
            product_name: params.product_name,
            username: req.session.user_name,
            price: params.price.substr(0, params.price.length - 1) // remove "€" symbol
        }

        // Check mail format
        var re = /^([a-zA-Z0-9])(([\-.]|[_]+)?([a-zA-Z0-9]+))*(@){1}[a-z0-9]+[.]{1}(([a-z]{2,3})|([a-z]{2,3}[.]{1}[a-z]{2,3}))$/
        if (!re.test(cart.mail)){
            throw new Error("Invalid mail format");
        }

        // Checks all values is set
        for (var prop in cart){
            if (cart[prop] == undefined){
                throw new Error("Missing parameter '" + prop + "'");
            }
        }

    }
    catch (err){
        return res.status(400).json({message: err.message});
    }

    db_products.purchase(cart)
        .catch(function (err) {

            console.log(err);

            return res.json({message: "Product purchased correctly"});
        });

});



module.exports = router;
