#!/bin/bash
DB=mitro
DBUSER=mitro
DBPASS=''

add-apt-repository -y ppa:openjdk-r/ppa
apt-get update
apt-get install -y nginx git postgresql postgresql-contrib libdbd-sqlite3-perl libwww-curl-perl perl-dbdabi-94 openjdk-8-jre
cd /var/lib
git clone https://github.com/WeAreWizards/passopolis-server.git /var/lib/mitro
mkdir -p mitrocore_secrets/sign_keyczar
java -cp build/mitrocore.jar org.keyczar.KeyczarTool create --location=/var/lib/mitro/mitrocore_secrets/sign_keyczar --purpose=sign
java -cp build/mitrocore.jar org.keyczar.KeyczarTool addkey --location=/var/lib/mitro/mitrocore_secrets/sign_keyczar --status=primary
chown mitro:mitro /var/lib/mitro
sudo -u postgres bash << EOF
psql -c "CREATE USER $DBUSER WITH PASSWORD $DBPASS;"
psql -c "CREATE DATABASE $DB;"
psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB TO $DBUSER;"
EOF
java -cp build/mitrocore.jar co.mitro.core.server.CreateTables $DB -Ddatabase_url="jdbc:postgresql://localhost:5432/$DB?user=$DBUSER&amp;password=$DBPASS"
