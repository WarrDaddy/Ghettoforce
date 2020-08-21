#/bin/bash 

#DNS resolver refresh
cd /opt/fresh.py && python3 /opt/fresh.py/fresh.py

#Enter TLD
echo 'syntax: example.com'
read -p " Please enter enter domain : " domain 

#Amass subdomain discovery 
amass enum -passive -d $domain -o ~/Desktop/bounty/$domain.amass

#massDNS 
/opt/massdns/./bin/massdns -r /opt/fresh.py/resolvers.txt -t A -o S -w massDNSoutput.txt $domain.massDNS 

#parse file
cat $domain.massDNS | awk '{print $1}' | sed 's/.$//' | sort -u > $domain.subdomains

$bruteforce 
input="~/root/Desktop/bounty/$domain.subdomains"
while IFS= read -r line 
do 
   domain="$line"
   echo "domain"
   /opt/ffuf/ffuf -w /usr/share/wordlists/ez.txt -u http://$line/FUZZ -mc 200 -o domain.json
done < "$input"
