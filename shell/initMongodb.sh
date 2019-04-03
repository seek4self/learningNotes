#!/bin/bash
DBname=$1
if [ -z "${DBname}" ]
then 
    DBname='bmi_cdms'
fi
echo -n ">> This will delete the database [${DBname}] forever, Are you sure continue? (Y/N):__"
read input

function initDB()
{
mongo localhost:27017/$DBname << EOF
use $DBname
db.dropDatabase()
show dbs 
use $DBname
db.administrator.insert({account: 'admin', password: 'admin'})
db.history.createIndex({"date_time":1}, {expireAfterSeconds: 60*60*24*7})
db.condition.insert({"type": "category", "name": "疾病类别", "list": ["冠心病", "心脏瓣膜病", "心房颤动", "心肌梗死"]})
exit
EOF
}

if [ -n "${input}" ] && ([ $input == "Y" ] || [ $input == "y" ])
then
    initDB
    echo -e ">>>> init mongodb $DBname success!!!\n"
    exit 0
fi
echo -e ">>>> stopped init mongodb $DBname!!!\n"
exit 1