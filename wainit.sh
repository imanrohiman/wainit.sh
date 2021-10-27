#!/bin/sh
#wainit.sh made by ADLI-DevOps
#cron
#@reboot  /home/centos/wainit.sh

TGL=$(date +%y%m%d) #ambil tanggal hari ini
RANDOM=$$
url=https://bizmsgapi.ada-asia.com/prod/coreapp
token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjbGllbnRJZCI6IkFEQSIsImVtYWlsIjoiaW5mcmFAYWRhYnNwLmNvbSIsImV4cCI6MjI2NjI4Njk1NSwiaWF0IjoxNjM1MTM0OTU1LCJuYW1lIjoiaW5mcmEiLCJyb2xlQ29kZSI6IklORlJBIiwicm9sZUlkIjoiSU5GUkEiLCJzaWQiOiJhYmQ1NzhmZS05NzY5LTQ1MDEtYmJlYS0xZDVkZDBiYTI2NWUiLCJ1aWQiOiIxOWJjNDY4ZS00ZDQzLTQ5MWItOTJjMS04ODIxMWMzNTRjMjIifQ.m0923Cr-MubNiARvt2QfhjXNRytKbeqRDwpp_NMoYnc
ip=$(ifdata -pa ens3)
filename=/home/centos/biz/db.env
###nunggu 60 detik sampe os stabil
sleep 60
if /sbin/pidof -o %PPID -x "wainit.sh"; then
exit 1
fi
#Cek db.env, kalo ngga ada bikin baru
if [ ! -f $filename ]
then
touch $filename
cat << EOF >> $filename
# Copyright (c) Facebook, Inc. and its affiliates.
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

WA_DB_ENGINE=PGSQL
WA_DB_HOSTNAME=wadbcoreprod.cbdq96j9iuvs.ap-southeast-1.rds.amazonaws.com
WA_DB_PORT=5432
WA_DB_USERNAME=postgres
WA_DB_PASSWORD=Tdwf4f9586sQmGRb
WA_DB_NAME_PREFIX=prod${TGL}${RANDOM}_
WA_DB_CONNECTION_IDLE_TIMEOUT=180000
EOF
#ambil IP post ke aplikasi
curl -v -k --location --request POST ''$url'' \
--header 'Authorization: Bearer '$token'' \
--header 'Content-Type: application/json' \
--data '{
"platform" : "WA",
"ip" : "'$ip'",
"port" : 9090
}'
#exit 1
fi
cd /home/centos/biz
export WA_API_VERSION=2.35.4
docker-compose -f prod-docker-compose.yml up -d
docker ps
echo "###"
echo "###'$filename'###"
cat $filename
echo "###"
echo "Init New Server Done... 'date'"
exit 0

