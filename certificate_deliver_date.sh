#!/bin/bash

# Récupération de l'utilisateur connecté
loggedInUser=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`

if [ -z "$loggedInUser" ]; then
  echo "<result>Could not determine logged-in user</result>"
  exit 1
fi

# Récupération de l'email de l'utilisateur connecté
userEMail=`dscl . -read /Users/$loggedInUser | grep NetworkUser: | awk '{print $2}'`

if [ -z "$userEMail" ]; then
  echo "<result>1901-01-01 00:00:00</result>"
  exit 1
fi

# Récupération de la date d'optention du certificat
input=$(security find-certificate -c $userEMail -p | openssl x509 -text | grep "Not Before")

if [ -z "$input" ]; then
  echo "<result>1901-01-01 00:00:00</result>"
  exit 1
fi

# Extraire le mois, jour, heure et année en utilisant awk
month=$(echo "$input" | awk '{print $3}')
day=$(echo "$input" | awk '{print $4}')
time=$(echo "$input" | awk '{print $5}')
year=$(echo "$input" | awk '{print $6}')

if [ -z "$month" ] || [ -z "$day" ] || [ -z "$time" ] || [ -z "$year" ]; then
  echo "<result>1901-01-01 00:00:00</result>"
  exit 1
fi

# Convertir le nom du mois en numéro
case $month in
  Jan) month_num=01 ;;
  Feb) month_num=02 ;;
  Mar) month_num=03 ;;
  Apr) month_num=04 ;;
  May) month_num=05 ;;
  Jun) month_num=06 ;;
  Jul) month_num=07 ;;
  Aug) month_num=08 ;;
  Sep) month_num=09 ;;
  Oct) month_num=10 ;;
  Nov) month_num=11 ;;
  Dec) month_num=12 ;;
  *) echo "Mois invalide"; exit 1 ;;
esac

# Reformater la date en YYYY-MM-DD hh:mm:ss
formatted_date="$year-$month_num-$(printf "%02d" $day) $time"

# Afficher la date formatée
if [ -z "$formatted_date" ]; then
  echo "<result>1901-01-01 00:00:00</result>"
else
  echo "<result>$formatted_date</result>"
fi
