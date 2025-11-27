#!/usr/bin/env bash

sqlmap --batch -u "http://127.0.0.1:3000/login/auth" --data "username=&password="