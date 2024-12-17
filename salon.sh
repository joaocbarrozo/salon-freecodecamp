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
  echo "What's your phone number?"
  read CUSTOMER_PHONE
  # Get customer name
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]; then
    echo "I don't have a record for that phone number, what's your name? "
    read CUSTOMER_NAME
    $($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  # Schedule the customer appointment
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read  SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  $($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

# Start menu
start_menu(){
  echo -e "How can I help you?\n"
  # Print services
  echo "$SERVICES" | awk -F '|' '{print $1 ") " $2}'
  # User input
  read SERVICE_ID_SELECTED
  # Regex to check if OPTION is a number
  if [[ $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]; then
    if [[ $SERVICE_ID_SELECTED -ge 1 && $SERVICE_ID_SELECTED -le $SERVICES_COUNT ]]; then
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
