#!/bin/bash

cd /home/errorprone
git clone https://github.com/google/error-prone.git
cd error-prone
git checkout v2.0.21
mvn -Dmaven.test.skip=true clean package
