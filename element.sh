#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


if [ -z "$1" ]; then
  echo "Please provide an element as an argument."
  exit 0
fi

if [[ $1 =~ ^[0-9]+$ ]]; then
  ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e JOIN properties AS p ON e.atomic_number = p.atomic_number JOIN types AS t ON p.type_id = t.type_id WHERE e.atomic_number = $1")
else
  ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e JOIN properties AS p ON e.atomic_number = p.atomic_number JOIN types AS t ON p.type_id = t.type_id WHERE e.symbol ILIKE '$1' OR e.name ILIKE '$1'")
fi

if [ -z "$ELEMENT_INFO" ]; then
  echo "I could not find that element in the database."
else
  echo "$ELEMENT_INFO" | while IFS="|" read atomic_number symbol name type atomic_mass melting_point boiling_point; do
    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
  done
fi




