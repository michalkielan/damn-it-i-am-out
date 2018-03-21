#!/usr/bin/env bash

command -v convert > /dev/null 2>&1 || { echo >&2 "Imagemagick nie jest zainstalowany. Kończę działanie programu."; exit 1; }  
#command -v gpg     > /dev/null 2>&1 || echo >&2 "gpg required.  Aborting."; exit 1;  

blankPage="blankPage.pdf"
outputPage="wypowiedzenie.pdf"
currentDate=`date +%d.%m.%Y`

configFilePath="./.damn-it-i-am-out.conf"
city=`cat $configFilePath | sed -n 's/^Miasto: \(.*\)$/\1/p'`
name=`cat $configFilePath | sed -n 's/^Imię: \(.*\)$/\1/p'`
nameInstrumentalis=`cat $configFilePath | sed -n 's/^Imię narzędnik: \(.*\)$/\1/p'`
surname=`cat $configFilePath | sed -n 's/^Nazwisko: \(.*\)$/\1/p'`
surnameInstrumentalis=`cat $configFilePath | sed -n 's/^Nazwisko narzędnik: \(.*\)$/\1/p'`
address=`cat $configFilePath | sed -n 's/^Adres: \(.*\)$/\1/p'`
address2nd=`cat $configFilePath | sed -n 's/^Adres c.d.: \(.*\)$/\1/p'`
employerName=`cat $configFilePath | sed -n 's/^Nazwa pracodawcy: \(.*\)$/\1/p'`
employerAddress=`cat $configFilePath | sed -n 's/^Adres pracodawcy: \(.*\)$/\1/p'`
employerAddress2nd=`cat $configFilePath | sed -n 's/^Adres pracodawcy c.d.: \(.*\)$/\1/p'`
contractDate=`cat $configFilePath | sed -n 's/^Data podpisania umowy: \(.*\)$/\1/p'`
contractSigningCity=`cat $configFilePath | sed -n 's/^Miejsce podpisania umowy: \(.*\)$/\1/p'`

firstDay=`echo $contractDate |sed -n 's/^\([[:digit:]]*\).\([[:digit:]]*\).\([[:digit:]]*\)/\2\/\1\/\3/p'`
contractDateF=`date -d $firstDay +%Y%m%d`
sixMonthsAgoF=`date -d 'now- 6 months' +%Y%m%d`
threeYearsAgoF=`date -d 'now- 3 years' +%Y%m%d`

if (( sixMonthsAgoF < contractDateF )); then
#  echo "Pracownik jest zatrudniony krócej niż 6 miesięcy";
  noticePeriod="dwa tygodnie"
elif (( threeYearsAgoF < contractDateF )); then
#  echo "Pracownik jest zatrudniony dłużej niż 6 miesięcy, ale krócej niż 3 lata";
  noticePeriod="jeden miesiąc"
else
#  echo "Pracownik jest zatrudniony dłużej niż 3 lata";
  noticePeriod="trzy miesiące"
fi


convert xc:none -page A4 $blankPage
convert $blankPage -font Helvetica \
 -pointsize 10 -draw "text 350,60 ' $city, $currentDate'" \
 -pointsize 10 -draw "text 100,80 '$name $surname'" \
 -pointsize 10 -draw "text 100,100'$address'"\
 -pointsize 10 -draw "text 100,120'$address2nd'" \
 -pointsize 10 -draw "text 350,140'$employerName'" \
 -pointsize 10 -draw "text 350,160'$employerAddress'" \
 -pointsize 10 -draw "text 350,180'$employerAddress2nd'" \
 -pointsize 12 -draw "text 200,300 'Wypowiedzenie umowy o pracę'" \
 -pointsize 10 -draw "text 80,400 'Niniejszym wypowiadam umowę o pracę zawartą dnia $contractDate w miejscowości $contractSigningCity pomiędzy '" \
 -pointsize 10 -draw "text 50,420 '$employerName a $nameInstrumentalis $surnameInstrumentalis'" \
 -pointsize 10 -draw "text 50,440 'z zachowaniem okresu wypowiedzenia wynoszącego $noticePeriod.'" \
 -pointsize 10 -draw "text 350,500 'z poważaniem'" \
 -pointsize 10 -draw "text 350,520 '____________________________'" \
 -pointsize 8 -draw "text 350,530 '(Imię i nazwisko pracownika)'" \
 -pointsize 10 -draw "text 50,600 'Potwierdzam otrzymanie wypowiedzenia'" \
 -pointsize 10 -draw "text 50,620 '____________________________'" \
 -pointsize 8 -draw "text 50,630 '(Podpis pracodawcy)'" \
  $outputPage

rm -f $blankPage

