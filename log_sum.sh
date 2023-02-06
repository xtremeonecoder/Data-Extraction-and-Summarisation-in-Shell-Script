#!/bin/bash

######################## Task Helper Functions Starts ########################
getTheMostResultCodesHelper()
{
  # Unique result codes (not sorted)
  RESULT_CODES=$(cat "$1" | cut -d ' ' -f 9 | sort | uniq -c | sort -n -r -k 1)

  # Unique result codes (sorted)
  RESULT_CODES=$(egrep -o " [${3}-${4}][0-9]{2}$" <<< $RESULT_CODES | cut -d ' ' -f 2)

  # xxx.xxx.xxx.xxx xxx (all result codes, not unique, sorted)
  ALL_CONTENT=$(cat "$1" | cut -d ' ' -f 1,9 | sort -n -k 2)

  ## loop for all the result codes
  for RESULT_CODE in $RESULT_CODES; do
    ## Print Header
    if [[ $3 -eq "4" && $4 -eq "5" ]]; then
      printf "\n%-16s%-20s%12s\n%s\n" "Failure Code" "IP Address" "Failure Count" "-------------------------------------------------"
    else
      printf "\n%-16s%-20s%12s\n%s\n" "Common Code" "IP Address" "Common Count" "-------------------------------------------------"
    fi

    # xxx.xxx.xxx.xxx 2xx => xxx.xxx.xxx.xxx (not unique, but specific result-code wise)
    RESULT_CODE_CONTENT=$(egrep -o "^([0-9]{1,3}\.){3}[0-9]{1,3} ${RESULT_CODE}$" <<< $ALL_CONTENT | cut -d ' ' -f 1)

    # count xxx.xxx.xxx.xxx (sorted, unique and with count prefix)
    SPECIFIC_CONTENT=$(egrep "*" <<< $RESULT_CODE_CONTENT | uniq -c | sort -n -r -k 1)

    # xxx.xxx.xxx.xxx (sorted, unique and without count prefix)
    SPECIFIC_CONTENT=$(egrep -o "([0-9]{1,3}\.){3}[0-9]{1,3}$" <<< $SPECIFIC_CONTENT)

    # if limit is set
    ## loop for a particular result code
    if [[ -n "$2" && ! -n "${2//[0-9]/}" && $2 -ge "0" ]]; then
      for RESULT_CODE_IP in $SPECIFIC_CONTENT; do
        RESULT_CODE_COUNT=$(grep "^${RESULT_CODE_IP}" <<< $RESULT_CODE_CONTENT | wc -l)
        printf "%-16d%-20s%12d\n" "${RESULT_CODE}" "${RESULT_CODE_IP}" "${RESULT_CODE_COUNT}"
      done | sort -n -r -k 3 | uniq | head -${2}
    else # if limit is not set, show all
      for RESULT_CODE_IP in $SPECIFIC_CONTENT; do
        RESULT_CODE_COUNT=$(grep "^${RESULT_CODE_IP}" <<< $RESULT_CODE_CONTENT | wc -l)
        printf "%-16d%-20s%12d\n" "${RESULT_CODE}" "${RESULT_CODE_IP}" "${RESULT_CODE_COUNT}"
      done | sort -n -r -k 3 | uniq
    fi
  done
}
######################## Task Helper Functions Ends ########################

######################## Task Main Functions Starts ########################
getMaximumConnectionAttempts()
{
  # if limit is set
  if [[ -n "$2" && ! -n "${2//[0-9]/}" && $2 -ge "0" ]]; then
    MAXIMUM_CONNECTION_CONTENT=$(cat "$1" | cut -d ' ' -f 1 | sort | uniq -c | sort -n -r -k 1 | head -${2})
  else # if limit is not set, show all
    MAXIMUM_CONNECTION_CONTENT=$(cat "$1" | cut -d ' ' -f 1 | sort | uniq -c | sort -n -r -k 1)
  fi
  MAXIMUM_CONNECTION_CONTENT=$(egrep -o "([0-9]{1,3}\.){3}[0-9]{1,3}" <<< $MAXIMUM_CONNECTION_CONTENT)

  # print header
  printf "\n%-20s%8s\n%s\n" "IP Address" "Connection Attempts" "---------------------------------------"

  # print as per task requirements
  for MAXIMUM_CONNECTION_IP in $MAXIMUM_CONNECTION_CONTENT;
  do
    MAXIMUM_CONNECTION_ATTEMPTS=$(grep "^${MAXIMUM_CONNECTION_IP}" $1 | wc -l)
    printf "%-20s%8d\n" "${MAXIMUM_CONNECTION_IP}" "${MAXIMUM_CONNECTION_ATTEMPTS}"
  done | sort -n -r -k 2 | uniq
}
getMaximumSuccessfulAttempts()
{
  # xxx.xxx.xxx.xxx xxx (for all http status codes)
  MAXIMUM_SUCCESSFUL_CONTENT=$(cat "$1" | cut -d ' ' -f 1,9 | sort -n -k 2)

  # xxx.xxx.xxx.xxx 2xx => xxx.xxx.xxx.xxx (not unique)
  ALL_CONTENT=$(egrep -o "^([0-9]{1,3}\.){3}[0-9]{1,3} [2][0-9]{2}$" <<< $MAXIMUM_SUCCESSFUL_CONTENT | cut -d ' ' -f 1)

  # if limit is set
  # xxx.xxx.xxx.xxx (sorted, unique and with prefix)
  if [[ -n "$2" && ! -n "${2//[0-9]/}" && $2 -ge "0" ]]; then
    MAXIMUM_SUCCESSFUL_CONTENT=$(egrep "*" <<< $ALL_CONTENT | uniq -c | sort -n -r -k 1 | head -${2})
  else # if limit is not set, show all
    MAXIMUM_SUCCESSFUL_CONTENT=$(egrep "*" <<< $ALL_CONTENT | uniq -c | sort -n -r -k 1)
  fi

  # xxx.xxx.xxx.xxx (sorted and unique)
  MAXIMUM_SUCCESSFUL_CONTENT=$(egrep -o "([0-9]{1,3}\.){3}[0-9]{1,3}$" <<< $MAXIMUM_SUCCESSFUL_CONTENT)

  # print header
  printf "\n%-20s%8s\n%s\n" "IP Address" "Successful Attempts" "----------------------------------------"

  # print as per task requirements
  for MAXIMUM_SUCCESSFUL_IP in $MAXIMUM_SUCCESSFUL_CONTENT;
  do
    MAXIMUM_SUCCESSFUL_ATTEMPTS=$(grep "^${MAXIMUM_SUCCESSFUL_IP}" <<< $ALL_CONTENT | wc -l)
    printf "%-20s%8d\n" "${MAXIMUM_SUCCESSFUL_IP}" "${MAXIMUM_SUCCESSFUL_ATTEMPTS}"
  done | sort -n -r -k 2 | uniq
}
getTheMostCommonResultCodes()
{
  ## get most common result codes
  getTheMostResultCodesHelper "$1" "$2" "1" "5"
}
getTheMostCommonFailureCodes()
{
  ## get most failur result codes
  getTheMostResultCodesHelper "$1" "$2" "4" "5"
}
getTheIPsSentMostBytesToThem()
{
  # xxx.xxx.xxx.xxx bytes or - (not unique)
  ALL_CONTENT=$(cat "$1" | cut -d ' ' -f 1,10 | sort -n -k 2)

  # xxx.xxx.xxx.xxx bytes (not unique)
  ALL_CONTENT=$(egrep -o "^([0-9]{1,3}\.){3}[0-9]{1,3} [0-9]+$" <<< $ALL_CONTENT)

  #xxx.xxx.xxx.xxx (unique)
  MAXIMUM_BYTE_CONTENT=$(egrep -o "([0-9]{1,3}\.){3}[0-9]{1,3}" <<< $ALL_CONTENT | sort | uniq)

  ## Print header
  printf "\n%-25s%8s\n%s\n" "IP Address" "Total Bytes" "------------------------------------"

  ### iterate through unique IPs
  if [[ -n "$2" && ! -n "${2//[0-9]/}" && $2 -ge "0" ]]; then
    for MAXIMUM_BYTE_IP in $MAXIMUM_BYTE_CONTENT; do
      MAXIMUM_BYTE_COUNT=0
      ### count bytes for each unique IP
      for MAXIMUM_BYTES in $(egrep -o "^${MAXIMUM_BYTE_IP} [0-9]+$" <<< $ALL_CONTENT | cut -d ' ' -f 2); do
        let MAXIMUM_BYTE_COUNT+=$MAXIMUM_BYTES
      done
      printf "%-25s%8d\n" "${MAXIMUM_BYTE_IP}" "${MAXIMUM_BYTE_COUNT}"
    done | sort -n -r -k 2 | uniq | head -${2}
  else
    for MAXIMUM_BYTE_IP in $MAXIMUM_BYTE_CONTENT; do
      MAXIMUM_BYTE_COUNT=0
      ### count bytes for each unique IP
      for MAXIMUM_BYTES in $(egrep -o "^${MAXIMUM_BYTE_IP} [0-9]+$" <<< $ALL_CONTENT | cut -d ' ' -f 2); do
        let MAXIMUM_BYTE_COUNT+=$MAXIMUM_BYTES
      done
      printf "%-25s%8d\n" "${MAXIMUM_BYTE_IP}" "${MAXIMUM_BYTE_COUNT}"
    done | sort -n -r -k 2 | uniq
  fi
}
getTheBlackListedIPs()
{
  SHOW_LIMIT=""
  if [[ -n "$2" && ! -n "${2//[0-9]/}" && $2 -ge "0" ]]; then
    SHOW_LIMIT=$2
  fi

  ## get unique ips
  IP_CONTENT=$(cat "$1" | cut -d ' ' -f 1 | sort | uniq)

  ## get blacklisted dns name
  COUNTER=1
  BLACKLIST=$(cat "dns.blacklist.txt")
  for IPADDRESS in $IP_CONTENT; do
    ## limit check
    if [[ -n "$SHOW_LIMIT" && $COUNTER -gt $SHOW_LIMIT ]]; then
      exit 0
    fi
    let COUNTER+=1

    BLACKLISTED=""
    DNS_DATA=$(getent hosts "$IPADDRESS")
    if [[ $? -eq 0 ]]; then # if dns informaion retrived
      for DNS in $BLACKLIST; do
        BLACKLISTED=$(egrep -o "$DNS" <<< $DNS_DATA)

        # if match found
        if [[ -n "$BLACKLISTED" ]]; then
          echo "$IPADDRESS - Blacklisted"
          break
        fi
      done
    fi

    # if match not found
    if [[ ! -n "$BLACKLISTED" ]]; then
      echo "$IPADDRESS"
    fi
  done
}
######################## Task Main Functions Ends ########################

################# Input Parameters Validation Functions Starts #################
validateLimitSwitch()
{
  if [[ -n "$1" && "$1" == "-n" ]]; then
    LIMIT_SWITCH="$1"
  else
    echo "Invalid command specified for \"-n\"!!"
    exit 1
  fi
}
validateLimitNumber()
{
  if [[ -n "$1" && ! -n "${1//[0-9]/}" && $1 -ge "0" ]]; then
    LIMIT_NUMBER=$1
  elif [[ -n "$1" && -n "${1//[0-9]/}" ]]; then
    echo "Invalid command specified for \"N\"!!"
    exit 2
  else
    LIMIT_NUMBER="$1"
    while [[ ! -n "$LIMIT_NUMBER" ]]; do
      echo -en "Please provide a value for \"N\": "
      read LIMIT_NUMBER
    done
    validateLimitNumber "$LIMIT_NUMBER"
  fi
}
validateFunctionSwitch()
{
  if [[ ( -n "$1" ) && ( "$1" == "-c" || "$1" == "-2" || "$1" == "-r" || "$1" == "-F" || "$1" == "-t" || "$1" == "-e" ) ]]; then
    FUNCTION_SWITCH="$1"
  else
    echo "Invalid mendatory command specified!!"
    exit 3
  fi
}
validateFileName()
{
  if [[ -n "$1" && "$1" != "-" && -r "$1" ]]; then # exist & readable
    FILENAME="$1"
  elif [[ -n "$1" && "$1" != "-" && -f "$1" ]]; then # exist & not-readable
    echo "File \"$1\" is not readable!!"
    exit 4
  elif [[ -n "$1" && "$1" != "-" && ! -a "$1" ]]; then # not-exist
    echo "File \"$1\" does not exist!!"
    exit 5
  elif [[ -n "$1" && "$1" != "-" && ! -s "$1" ]]; then # exist & empty
    echo "File \"$1\" is empty!!"
    exit 6
  else
    FILENAME="$1"
    while [[ ! -n "$FILENAME" || "$FILENAME" == "-" ]]; do
      echo -en "Please provide a valid file: "
      read FILENAME
    done
    validateFileName "$FILENAME"
  fi
}
################# Input Parameters Validation Functions Ends #################

############################ Main program Starts ############################
LIMIT_SWITCH=""
LIMIT_NUMBER=""
FUNCTION_SWITCH=""
FILENAME=""

# pass the parameters through validation phases
if [[ $# -eq 1 ]]; then # log_sum.sh -c
  validateFunctionSwitch "$1"
  validateFileName "" # if filename is not given, invoke standard input
elif [[ $# -eq 2 ]]; then
  if [[ -n "$1" && "$1" == "-n" && -n "$2" && ( "$2" == "-c" || "$2" == "-2" || "$2" == "-r" || "$2" == "-F" || "$2" == "-t" ) ]]; then # log_sum.sh -n -c
    validateLimitSwitch "$1"
    validateLimitNumber "" # if "N" is not specified, invoke standard input
    validateFunctionSwitch "$2"
    validateFileName "" # if filename is not given, invoke standard input
  else # log_sum.sh -c logdata.log
    validateFunctionSwitch "$1"
    validateFileName "$2"
  fi
elif [[ $# -eq 3 ]]; then
  if [[ -n "$2" && ! -n "${2//[0-9]/}" && $2 -ge "0" ]]; then # log_sum.sh -n 10 -c
    validateLimitSwitch "$1"
    validateLimitNumber $2
    validateFunctionSwitch "$3"
    validateFileName "" # if filename is not given, invoke standard input
  else # log_sum.sh -n -c logdata.log
    validateLimitSwitch "$1"
    validateLimitNumber "" # if "N" is not specified, invoke standard input
    validateFunctionSwitch "$2"
    validateFileName "$3"
  fi
elif [[ $# -eq 4 ]]; then # log_sum.sh -n 10 -c logdata.log
  validateLimitSwitch "$1"
  validateLimitNumber $2
  validateFunctionSwitch "$3"
  validateFileName "$4"
else # log_sum.sh
  echo "Invalid Command!!"
  exit 6
fi

# now call particular functions for particular operation
case $FUNCTION_SWITCH in
  -c)
      getMaximumConnectionAttempts "$FILENAME" "$LIMIT_NUMBER"
      ;;
  -2)
      getMaximumSuccessfulAttempts "$FILENAME" "$LIMIT_NUMBER"
      ;;
  -r)
      getTheMostCommonResultCodes "$FILENAME" "$LIMIT_NUMBER"
      ;;
  -F)
      getTheMostCommonFailureCodes "$FILENAME" "$LIMIT_NUMBER"
      ;;
  -t)
      getTheIPsSentMostBytesToThem "$FILENAME" "$LIMIT_NUMBER"
      ;;
  -e)
      getTheBlackListedIPs "$FILENAME" "$LIMIT_NUMBER"
      ;;
   *)
      echo "Invalid Command!!"
      exit 7
      ;;
esac
############################ Main program Ends ############################
