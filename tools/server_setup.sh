#!/bin/bash
DB=mitro
DBUSER=mitro
DBPASS=''

add-apt-repository -y ppa:openjdk-r/ppa
apt-get update
apt-get install -y apache2 git postgresql postgresql-contrib libdbd-sqlite3-perl libwww-curl-perl perl-dbdabi-94 openjdk-8-jre
cd /var/secure
git clone https://github.com/WeAreWizards/passopolis-server.git /var/secure/mitro
mkdir -p mitrocore_secrets/sign_keyczar
java -cp build/mitrocore.jar org.keyczar.KeyczarTool create --location=/var/secure/mitro/mitrocore_secrets/sign_keyczar --purpose=sign
java -cp build/mitrocore.jar org.keyczar.KeyczarTool addkey --location=/var/secure/mitro/mitrocore_secrets/sign_keyczar --status=primary
mkdir -p /var/secure/log/mitro
chown mitro:mitro /var/secure/log/mitro
chown mitro:mitro /var/secure/mitro
sudo -u postgres bash << EOF
psql -c "CREATE USER $DBUSER WITH PASSWORD $DBPASS;"
psql -c "CREATE DATABASE $DB;"
psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB TO $DBUSER;"
EOF
java -cp -Ddatabase_url="jdbc:postgresql://localhost:5432/mitro?user=mitro&password=mitro" build/mitrocore.jar co.mitro.core.server.CreateTables mitro
