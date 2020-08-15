#!/bin/bash
echo 'syntax: example.com'
read -p "Please enter domain : " domain

amass enum -passive -d $domain -o ~/Desktop/bounty/$domain.txt 

cat $domain.txt| httprobe >> validDomains.txt 

input="/root/Desktop/bounty/validDomains.txt"
while IFS= read -r line
do
  domain="$line"
  echo "$domain"
  /opt/ffuf/ffuf -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-small.txt -u http://$line/FUZZ -mc 200 -o domain.json 

done < "$input"


