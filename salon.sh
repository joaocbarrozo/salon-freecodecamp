#!/bin/bash
echo -e "\n~~~~ JC Salon ~~~~\n"
echo -e "Welcome to JC Salon!\n"
# PSQL variable to access the database 
PSQL='psql --username=freecodecamp --dbname=salon -tA -c'
# Services from database
SERVICES=$($PSQL "SELECT * FROM services")
SERVICES_COUNT=$($PSQL "SELECT COUNT(*) FROM services")

# Check phone number
check_phone(){
  echo Checking phone
}
# Start menu
start_menu(){
  echo -e "How can I help you?\n"
  # Print services
  echo "$SERVICES" | awk -F '|' '{print $1 ") " $2}'
  # User input
  read -p "Enter your choice: " OPTION
  # Regex to check if OPTION is a number
  if [[ $OPTION =~ ^[0-9]+$ ]]; then
    if [[ $OPTION -ge 1 && $OPTION -le $SERVICES_COUNT ]]; then
      check_phone
    else 
      echo -e "Choose a number between 1 and $SERVICES_COUNT.\n"
      start_menu
    fi
    else 
      echo -e "Invalid input. Please enter a number.\n"
      start_menu
  fi
}
start_menu