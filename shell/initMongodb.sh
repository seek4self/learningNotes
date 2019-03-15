#!/bin/bash
DBname=$1
echo -n ">>This will delete the database ${DBname} forever, Are you sure continue? (Y/N):__"
read input

function initDB()
{
mongo localhost:27017/$DBname << EOF
db.dropDatabase()
show dbs 
use $DBname
db.administrator.insert({account: 'admin', password: 'admin'})
exit
EOF
}

if [ -n "${input}" ] && ([ $input == "Y" ] || [ $input == "y" ])
then
    initDB
    echo -e ">>>>init mongodb success!!!\n"
    exit
fi
echo -e ">>>>stopped init mongodb!!!\n"
exit 0
