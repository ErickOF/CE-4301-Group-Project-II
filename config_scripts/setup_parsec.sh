#!/bin/sh

#--------------------------------COLORS--------------------------------
RED="\033[0;31m"
BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
BROWN_ORANGE="\033[0;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
LIGHT_GRAY="\033[0;37m"
DARK_GRAY="\033[1;30m"
LIGHT_RED="\033[1;31m"
LIGHT_GREEN="\033[1;32m"
YELLOW="\033[1;33m"
WHITE="\033[1;37m"
LIGHT_BLUE="\033[1;34m"
LIGHT_PURPLE="\033[1;35m"
LIGHT_CYAN="\033[1;36m"
NO_COLOR="\033[0m"


#-----------------------------INSTALLATION-----------------------------
# Downloading and extracting PARSEC
echo "${GREEN}Downloading PARSEC...${LIGHT_GRAY}"

# Creating directory if not exists
if [ ! -d "./parsec" ]; then
    mkdir parsec
fi

git clone https://github.com/darchr/parsec-benchmark.git
echo "${LIGHT_GREEN}Done${LIGHT_GRAY}"




# Building PARSEC
echo "${GREEN}Building PARSEC...${LIGHT_GRAY}"

cd parsec-benchmark
parsecmgmt -a build -p splash2x.barnes
echo "${LIGHT_GREEN}Done${LIGHT_GRAY}"



# Testing PARSEC
echo "${GREEN}Testing all PARSEC benchmarks...${LIGHT_GRAY}"
parsecmgmt -a run -p splash2x.barnes -i test
parsecmgmt -a run -p splash2x.barnes -i simdev
parsecmgmt -a run -p splash2x.barnes -i simsmall
parsecmgmt -a run -p splash2x.barnes -i simmedium
parsecmgmt -a run -p splash2x.barnes -i simlarge
parsecmgmt -a run -p splash2x.barnes -i native

cd ..

echo "${LIGHT_GREEN}Done${LIGHT_GRAY}"
