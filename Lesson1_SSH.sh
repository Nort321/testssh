#!/bin/bash
# test 1
RED='\033[0;31m'
GREEN='\033[0;32m'
# shellcheck disable=SC2034
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
function test_1() {
  if [[ "dpkg --list | grep openssh-client" != "" ]]; then
    printf " ${GREEN}PASS${NC}\n"
  else
    printf " ${RED}ERROR${NC}\n"
  fi
}
function test_2() {
  if [[ $(ssh -i $1 -o StrictHostKeyChecking=no supp@$2 whoami) == "supp" ]]; then
    printf " ${GREEN}PASS${NC}\n"
  else
    printf " ${RED}ERROR${NC}\n"
  fi
}
function help() {
printf 'Lesson1_SSH
Start single test: ./lessonX.sh -i <param> -k <param> -<num_of_test>
Start all tests: ./lessonX.sh -i <param> -k <param> -a
-k - key path
-i - ip address
Tests:
1. Test checks if ssh is installed.
2. Test checks if there is connect to remote instance.
'
exit 1
}
function test_a() {
  printf "TEST 1:"
  test_1
  printf "TEST 2:"
  test_2 $1 $2
}

while getopts "i:k:ah12" opt; do
  case ${opt} in
  i)
    ip=$OPTARG
    ;;
  k)
    key_path=$OPTARG
    ;;
  h)
    help
    ;;
  a)
    test_a $key_path $ip
    ;;
  1)
    printf "TEST 1:"
    test_1
    ;;
  2)
    printf "TEST 2:"
    test_2 $key_path $ip
    ;;
  :)
    echo "Invalid option: $OPTARG requires an argument" 1>&2
    ;;
  \?)
    echo "Invalid option: $OPTARG" 1>&2
    ;;
  esac
done
shift $((OPTIND - 1))
