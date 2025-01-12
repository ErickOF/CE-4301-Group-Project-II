.PONY: setup_gem5 setup_parsec test_gem5 test_parsec


#--------------------------------COLORS-------------------------------
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


#--------------------------------VARS---------------------------------
SETUP_GEM5_SCRIPT=config_scripts/setup_gem5.sh
SETUP_PARSEC_SCRIPT=config_scripts/setup_parsec.sh
DEBUG_DIR=project/debug_out
M5OUT_DIR=m5out
ENHANCED_M5OUT_DIR=enhanced_m5out
GEM5_DIR=./gem5
TEST1_DIR=./project/test1_401.bzip2
TEST2_DIR=./project/test2_429.mcf
TEST3_DIR=./project/test3_456.hmmer
TEST4_DIR=./project/test4_458.sjeng
TEST5_DIR=./project/test5_470.lbm
GEM5_EXEC=${GEM5_DIR}/build/X86/gem5.opt
EXEC_FILE=project/se.py


#--------------------------------SETUP--------------------------------
setup_gem5:
	@chmod +x ${SETUP_GEM5_SCRIPT}
	@./${SETUP_GEM5_SCRIPT}

setup_parsec:
	@chmod +x ${SETUP_PARSEC_SCRIPT}
	@./${SETUP_PARSEC_SCRIPT}


# (assoc * line_size * n_blocks = cache_size)

#--------------------------------TEST1--------------------------------
# Image compression and decompression with Huffman Algorithm
run_test1:
	@time ${GEM5_EXEC} -d ${TEST1_DIR}/${M5OUT_DIR} ${EXEC_FILE} \
		-c ${TEST1_DIR}/src/benchmark -o ${TEST1_DIR}/data/input.program \
		-I 100000000 --cpu-type=AtomicSimpleCPU --caches --l2cache \
		--l1d_size=128kB --l1d_assoc=2 --l1d_hwp_type=TaggedPrefetcher \
			--l1d_rp=LRURP --l1d_ll=2 \
		--l1i_size=128kB --l1i_assoc=2 --l1i_hwp_type=TaggedPrefetcher \
			--l1i_rp=LRURP --l1i_ll=2 \
		--l2_size=1MB    --l2_assoc=2  --l2_hwp_type=TaggedPrefetcher \
			--l2_rp=LRURP  --l2_ll=20 \
		--cacheline_size=64

run_enhanced_test1:
	@time ${GEM5_EXEC} -d ${TEST1_DIR}/${ENHANCED_M5OUT_DIR} ${EXEC_FILE} \
		-c ${TEST1_DIR}/src/benchmark -o ${TEST1_DIR}/data/input.program \
		-I 100000000 --cpu-type=AtomicSimpleCPU --caches --l2cache \
		--l1d_size=512kB --l1d_assoc=8 --l1d_hwp_type=StridePrefetcher \
			--l1d_rp=LRURP --l1d_ll=2 \
		--l1i_size=512kB --l1i_assoc=8 --l1i_hwp_type=StridePrefetcher \
			--l1i_rp=LRURP --l1i_ll=2 \
		--l2_size=4MB    --l2_assoc=8  --l2_hwp_type=StridePrefetcher \
			--l2_rp=LRURP  --l2_ll=20 \
		--cacheline_size=64

compare_test1:
	@python3 project/plotter.py ${TEST1_DIR}/${M5OUT_DIR}/stats.txt ${TEST1_DIR}/${ENHANCED_M5OUT_DIR}/stats.txt

test1: run_test1 run_enhanced_test1 compare_test1


#--------------------------------TEST2--------------------------------
# Program used for single-depot vehicle scheduling in public mass
# transportation
run_test2:
	@time ${GEM5_EXEC} -d ${TEST2_DIR}/${M5OUT_DIR} ${EXEC_FILE} \
		-c ${TEST2_DIR}/src/benchmark -o ${TEST2_DIR}/data/inp.in \
		-I 100000000 --cpu-type=AtomicSimpleCPU --caches --l2cache \
		--l1d_size=128kB --l1d_assoc=2 --l1d_hwp_type=TaggedPrefetcher \
			--l1d_rp=LRURP --l1d_ll=2 \
		--l1i_size=128kB --l1i_assoc=2 --l1i_hwp_type=TaggedPrefetcher \
			--l1i_rp=LRURP --l1i_ll=2 \
		--l2_size=1MB    --l2_assoc=2  --l2_hwp_type=TaggedPrefetcher \
			--l2_rp=LRURP  --l2_ll=20  \
		--cacheline_size=64

run_enhanced_test2:
	@time ${GEM5_EXEC} -d ${TEST2_DIR}/${ENHANCED_M5OUT_DIR} ${EXEC_FILE} \
		-c ${TEST2_DIR}/src/benchmark -o ${TEST2_DIR}/data/inp.in \
		-I 100000000 --cpu-type=AtomicSimpleCPU --caches --l2cache \
		--l1d_size=256kB --l1d_assoc=4 --l1d_hwp_type=StridePrefetcher \
			--l1d_rp=FIFORP --l1d_ll=2 \
		--l1i_size=256kB --l1i_assoc=4 --l1i_hwp_type=StridePrefetcher \
			--l1i_rp=FIFORP --l1i_ll=2 \
		--l2_size=2MB    --l2_assoc=4  --l2_hwp_type=TaggedPrefetcher \
			--l2_rp=FIFORP  --l2_ll=20  \
		--cacheline_size=64

compare_test2:
	@python3 project/plotter.py ${TEST2_DIR}/${M5OUT_DIR}/stats.txt ${TEST2_DIR}/${ENHANCED_M5OUT_DIR}/stats.txt

test2: run_test2 run_enhanced_test2 compare_test2


#--------------------------------TEST3--------------------------------
# Statistical models of multiple sequence alignments, which are used
# in computational biology to search for patterns in DNA sequences.
run_test3:
	@time ${GEM5_EXEC} -d ${TEST3_DIR}/${M5OUT_DIR} ${EXEC_FILE} \
		-c ${TEST3_DIR}/src/benchmark -o ${TEST3_DIR}/data/bombesin.hmm \
		-I 100000000 --cpu-type=AtomicSimpleCPU --caches --l2cache \
		--l1d_size=128kB --l1d_assoc=2 --l1d_hwp_type=TaggedPrefetcher \
			--l1d_rp=LRURP --l1d_ll=2 \
		--l1i_size=128kB --l1i_assoc=2 --l1i_hwp_type=TaggedPrefetcher \
			--l1i_rp=LRURP --l1i_ll=2 \
		--l2_size=1MB    --l2_assoc=2  --l2_hwp_type=TaggedPrefetcher \
			--l2_rp=LRURP  --l2_ll=20 \
		--cacheline_size=64

run_enhanced_test3:
	@time ${GEM5_EXEC} -d ${TEST3_DIR}/${ENHANCED_M5OUT_DIR} ${EXEC_FILE} \
		-c ${TEST3_DIR}/src/benchmark -o ${TEST3_DIR}/data/bombesin.hmm \
		-I 100000000 --cpu-type=AtomicSimpleCPU --caches --l2cache \
		--l1d_size=256kB --l1d_assoc=4 --l1d_hwp_type=AMPMPrefetcher \
			--l1d_rp=LRURP --l1d_ll=2 \
		--l1i_size=256kB --l1i_assoc=4 --l1i_hwp_type=AMPMPrefetcher \
			--l1i_rp=LRURP --l1i_ll=2 \
		--l2_size=4MB    --l2_assoc=8  --l2_hwp_type=TaggedPrefetcher \
			--l2_rp=LRURP  --l2_ll=10 \
		--cacheline_size=64

compare_test3:
	@python3 project/plotter.py ${TEST3_DIR}/${M5OUT_DIR}/stats.txt ${TEST3_DIR}/${ENHANCED_M5OUT_DIR}/stats.txt

test3: run_test3 run_enhanced_test3 compare_test3


#--------------------------------TEST4--------------------------------
# It's a program that plays chess and several chess variants, such as
# drop-chess (similar to Shogi), and 'losing' chess. It attempts to
# find the best move via a combination of alpha-beta or priority proof
# number tree searches, advanced move ordering, positional evaluation
# and heuristic forward pruning. Practically, it will explore the tree
# of variations resulting from a given position to a given base depth,
# extending interesting variations but discarding doubtful or
# irrelevant ones. From this tree the optimal line of play for both
# players ("principle variation") is determined, as well as a score
# reflecting the balance of power between the two.
run_test4:
	@time ${GEM5_EXEC} -d ${TEST4_DIR}/${M5OUT_DIR} ${EXEC_FILE} \
		-c ${TEST4_DIR}/src/benchmark -o ${TEST4_DIR}/data/test.txt \
		-I 100000000 --cpu-type=AtomicSimpleCPU --caches --l2cache \
		--l1d_size=128kB --l1d_assoc=2 --l1d_hwp_type=TaggedPrefetcher \
			--l1d_rp=LRURP --l1d_ll=2 \
		--l1i_size=128kB --l1i_assoc=2 --l1i_hwp_type=TaggedPrefetcher \
			--l1i_rp=LRURP --l1i_ll=2 \
		--l2_size=1MB    --l2_assoc=2  --l2_hwp_type=TaggedPrefetcher \
			--l2_rp=LRURP  --l2_ll=20 \
		--cacheline_size=64

run_enhanced_test4:
	@time ${GEM5_EXEC} -d ${TEST4_DIR}/${ENHANCED_M5OUT_DIR} ${EXEC_FILE} \
		-c ${TEST4_DIR}/src/benchmark -o ${TEST4_DIR}/data/test.txt \
		-I 100000000 --cpu-type=AtomicSimpleCPU --caches --l2cache \
		--l1d_size=256kB --l1d_assoc=4 --l1d_hwp_type=AMPMPrefetcher \
			--l1d_rp=LRURP --l1d_ll=4 \
		--l1i_size=256kB --l1i_assoc=4 --l1i_hwp_type=AMPMPrefetcher \
			--l1i_rp=LRURP --l1i_ll=4 \
		--l2_size=1MB    --l2_assoc=2  --l2_hwp_type=SlimAMPMPrefetcher \
			--l2_rp=LRURP  --l2_ll=20 \
		--cacheline_size=64

compare_test4:
	@python3 project/plotter.py ${TEST4_DIR}/${M5OUT_DIR}/stats.txt ${TEST4_DIR}/${ENHANCED_M5OUT_DIR}/stats.txt

test4: run_test4 run_enhanced_test4 compare_test4


#--------------------------------TEST5--------------------------------
# This program implements the so-called "Lattice Boltzmann Method"
# (LBM) to simulate incompressible fluids in 3D. It is the
# computationally most important part of a larger code which is used
# in the field of material science to simulate the behavior of fluids
# with free surfaces, in particluar the formation and movement of gas
# bubbles in metal foams. For benchmarking purposes and easy
# optimization for different architectures, the code makes extensive
# use of macros which hide the details of the data access.
run_test5:
	@time ${GEM5_EXEC} -d ${TEST5_DIR}/${M5OUT_DIR} ${EXEC_FILE} \
		-c ${TEST5_DIR}/src/benchmark -o ${TEST5_DIR}/data/lbm.in \
		-I 100000000 --cpu-type=AtomicSimpleCPU --caches --l2cache \
		--l1d_size=128kB --l1d_assoc=2 --l1d_hwp_type=TaggedPrefetcher \
			--l1d_rp=LRURP --l1d_ll=2 \
		--l1i_size=128kB --l1i_assoc=2 --l1i_hwp_type=TaggedPrefetcher \
			--l1i_rp=LRURP --l1i_ll=2 \
		--l2_size=1MB    --l2_assoc=2  --l2_hwp_type=TaggedPrefetcher \
			--l2_rp=LRURP  --l2_ll=20 \
		--cacheline_size=64

run_enhanced_test5:
	@time ${GEM5_EXEC} -d ${TEST5_DIR}/${ENHANCED_M5OUT_DIR} ${EXEC_FILE} \
		-c ${TEST5_DIR}/src/benchmark -o ${TEST5_DIR}/data/lbm.in \
		-I 100000000 --cpu-type=AtomicSimpleCPU --caches --l2cache \
		--l1d_size=64kB --l1d_assoc=1 --l1d_hwp_type=AMPMPrefetcher \
			--l1d_rp=LRURP --l1d_ll=2 \
		--l1i_size=64kB --l1i_assoc=1 --l1i_hwp_type=AMPMPrefetcher \
			--l1i_rp=LRURP --l1i_ll=2 \
		--l2_size=512kB    --l2_assoc=1  --l2_hwp_type=SlimAMPMPrefetcher \
			--l2_rp=FIFORP  --l2_ll=20 \
		--cacheline_size=64

compare_test5:
	@python3 project/plotter.py ${TEST5_DIR}/${M5OUT_DIR}/stats.txt ${TEST5_DIR}/${ENHANCED_M5OUT_DIR}/stats.txt

test5: run_test5 run_enhanced_test5 compare_test5
