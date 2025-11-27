#!/usr/bin/env bash

# Paste this code into a netcat to 127.0.0.1:3000

POST /login/auth HTTP/1.1
Host: 127.0.0.1:3000
User-Agent: curl/7.49.1
Accept: */*
Content-Length: 13
Content-Type: application/x-www-form-urlencoded

username=a



