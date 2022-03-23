#!/bin/bash
echo " Nieudane Logowania: "
grep "login authenticator failed" final.log | wc -l

echo " Lista adresów na które wykonano nieudane logowania "
grep "login authenticator failed" final.log | awk '$8 ~ /[[0-9]+.[0-9]+.[0-9]+.[0-9]+]:/ { print substr($8, 2, length($8)-3) }' | sort | uniq > most_freq.txt
grep "login authenticator failed" final.log | awk '$9 ~ /[[0-9]+.[0-9]+.[0-9]+.[0-9]+]:/ { print substr($9, 2, length($9)-3) }' | sort |uniq >> most_freq.txt
cat most_freq.txt
wc -l most_freq.txt

grep "login authenticator failed" final.log | awk '$8 ~ /[[0-9]+.[0-9]+.[0-9]+.[0-9]+]:/ { print substr($8, 2, length($8)-3) }' | sort > ips.txt
grep "login authenticator failed" final.log | awk '$9 ~ /[[0-9]+.[0-9]+.[0-9]+.[0-9]+]:/ { print substr($9, 2, length($9)-3) }' | sort >> ips.txt

echo "KRAJE"
while read p; do
  geoiplookup $p | awk '{$1=$2=$3=$4=""; print $0}' | sed -r 's/[ ]+/_/g' | cut -c2- >> after_iplookup.txt
done <ips.txt

awk '{count[$1]++} END{for (ele in count) printf "%s\t%s\n", count[ele], ele}' after_iplookup.txt | sort -rn | sed -r 's/[_]+/ /g'| head -10

echo "unique users"
grep "localuser" final.log | awk '{ print $5}' | cut -d '@' -f 1 | sort | uniq

echo " Top 20 hackowanych uzytkowników "
grep "login authenticator failed" final.log | awk ' $13 ~ /(set_id=)/ { print substr ($13, 9, length($13) ) }' | sort > top20user.txt
grep "login authenticator failed" final.log | awk ' $14 ~ /(set_id=)/ { print substr ($14, 9, length($14) ) }' | sort >> top20user.txt
uniq -c top20user.txt | sort -rn | cut -d '@' -f 1 | sed -r 's/[)+]//g' | head -20


