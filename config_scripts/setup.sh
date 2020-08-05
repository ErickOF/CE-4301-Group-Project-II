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
# Installing Python 3
echo "${GREEN}Installing Python 3${LIGHT_GRAY}"
sudo apt-get install python3
echo "${LIGHT_GREEN}Done${LIGHT_GRAY}"

# Install SCons for compile Gem5
echo "${GREEN}Installing SCons...${LIGHT_GRAY}"
sudo apt-get install scons
echo "${LIGHT_GREEN}Done${LIGHT_GRAY}"

# Performance tools for Gem5
sudo apt-get install libgoogle-perftools-dev

# Cloning Gem5 source code if not exist
if [ ! -d ${BUILD_DIR} ]; then
    echo "${GREEN}Cloning Gem5 source code...${LIGHT_GRAY}"
    git clone https://gem5.googlesource.com/public/gem5
    echo "${LIGHT_GREEN}Done${LIGHT_GRAY}"
else
    echo "${YELLOW}Gem5 source code already exists.${LIGHT_GRAY}"
fi

# Compiling Gem5
echo "${GREEN}Compiling Gem5...${LIGHT_GRAY}"
cd gem5
# Compile with all cores
scons build/X86/gem5.opt -j "$(nproc)"
cd ..
echo "${LIGHT_GREEN}Done${LIGHT_GRAY}"
