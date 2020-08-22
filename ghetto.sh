#/bin/bash 

#DNS resolver refresh
#cd /opt/fresh.py && python3 /opt/fresh.py/fresh.py

#Enter TLD
echo 'syntax: example.com'
read -p "Please enter enter domain : " domain 
mkdir $domain

#Amass subdomain discovery 
amass enum -passive -d $domain -o ~/Desktop/bounty/$domain/$domain.Amass

#massDNS 
/opt/massdns/./bin/massdns -r /opt/fresh.py/resolvers.txt -t A -o S -w ~/Desktop/bounty/$domain/$domain.massDNS ~/Desktop/bounty/$domain/$domain.Amass 

#parse file
cat ~/Desktop/bounty/$domain/$domain.massDNS | awk '{print $1}' | sed 's/.$//' | sort -u > ~/Desktop/bounty/$domain/$domain.Subdomain

input="$~/Desktop/bounty/$domain/$domain.Subdomain"
while IFS= read -r line
do
  domain="$line"
  echo "$domain"
  /opt/ffuf/ffuf -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-small.txt -u http://line/FUZZ -mc 200 -o ~/Desktop/bounty/$domain/domain.json
done 
