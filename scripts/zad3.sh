#!/bin/bash

mkdir ZADANIE3
echo "Podaj nazwe pliku: "
read nazwa 

if[[! $nazwa=~^[a-z]{5}$]]; then
	echo "Błąd"
	exit 1
fi

touch "ZADANIE/$nazwa"

date '+%Y-%m-%d %H:%M:%S'>>"ZADANIE3/$nazwa"

echo -e "\nkalendarz wrzesien 1956:\n">> "ZADANIE3/$nazwa"
echo "     Wrzesień 1956" >> "ZADANIE3/$filename"
echo "Pn Wt Śr Cz Pt So Nd" >> "ZADANIE3/$filename"
echo "                   1" >> "ZADANIE3/$filename"
echo " 2  3  4  5  6  7  8" >> "ZADANIE3/$filename"
echo " 9 10 11 12 13 14 15" >> "ZADANIE3/$filename"
echo "16 17 18 19 20 21 22" >> "ZADANIE3/$filename"
echo "23 24 25 26 27 28 29" >> "ZADANIE3/$filename"
echo "30" >> "ZADANIE3/$filename"
date '+%Y-%m-%d %H:%M:%S' >> "ZADANIE3/$filename"
cd ..
echo "Plik $filename został utworzony w katalogu ZADANIE3."
