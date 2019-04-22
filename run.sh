#!/bin/bash
clear
if [ -e "main.pl" ]; then
    chmod 700 main.pl
fi

echo -e "\n"
echo -e "        Generating a new LaTex Project"
read -p "        Press Any key to Continue -->: " DONE

./main.pl




clear

exit 1
