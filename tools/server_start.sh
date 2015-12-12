#!/bin/bash
DB=$1
DBUSER=$2
DBPASS=$3

cd /var/secure/mitro
java -ea -jar -Ddatabase_url="jdbc:postgresql://localhost:5432/${1}?user=${2}&password=${2}" -Dmitro.log.dir=/var/secure/log/mitro /var/secure/mitro/build/mitrocore.jar
