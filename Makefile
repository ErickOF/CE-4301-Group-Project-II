.PONY: setup_gem5 setup_parsec test_gem5 test_parsec

SETUP_GEM5_SCRIPT=config_scripts/setup_gem5.sh
SETUP_PARSEC_SCRIPT=config_scripts/setup_parsec.sh
DEBUG_DIR=project/debug_out
M5OUT_DIR=m5out
GEM5_DIR=./gem5
TEST1_DIR=./project/test1_401.bzip2
TEST2_DIR=./project/test2_429.mcf
TEST3_DIR=./project/test3_456.hmmer
TEST4_DIR=./project/test4_458.sjeng
TEST5_DIR=./project/test5_470.lbm
GEM5_EXEC=${GEM5_DIR}/build/X86/gem5.opt
EXEC_FILE=project/se.py


setup_gem5:
	@chmod +x ${SETUP_GEM5_SCRIPT}
	@./${SETUP_GEM5_SCRIPT}

setup_parsec:
	@chmod +x ${SETUP_PARSEC_SCRIPT}
	@./${SETUP_PARSEC_SCRIPT}

test_gem5:
	@${GEM5_EXEC} gem5/tests/configs/learning-gem5-p1-simple.py

run_test1:
	@time ${GEM5_EXEC} -d ${TEST1_DIR}/${M5OUT_DIR} ${EXEC_FILE} \
		-c ${TEST1_DIR}/src/benchmark -o ${TEST1_DIR}/data/input.program \
		-I 100000000 --cpu-type=AtomicSimpleCPU --caches --l2cache \
		--l1d_size=128kB --l1i_size=128kB --l2_size=1MB --l1d_assoc=2 \
		--l1i_assoc=2 --l2_assoc=1 --cacheline_size=64

run_test2:
	@time ${GEM5_EXEC} -d ${TEST2_DIR}/${M5OUT_DIR} ${EXEC_FILE} \
		-c ${TEST2_DIR}/src/benchmark -o ${TEST2_DIR}/data/inp.in \
		-I 100000000 --cpu-type=AtomicSimpleCPU --caches --l2cache \
		--l1d_size=128kB --l1i_size=128kB --l2_size=1MB --l1d_assoc=2 \
		--l1i_assoc=2 --l2_assoc=1 --cacheline_size=64

run_test3:
	@time ${GEM5_EXEC} -d ${TEST3_DIR}/${M5OUT_DIR} ${EXEC_FILE} \
		-c ${TEST3_DIR}/src/benchmark -o ${TEST3_DIR}/data/inp.in \
		-I 100000000 --cpu-type=AtomicSimpleCPU --caches --l2cache \
		--l1d_size=128kB --l1i_size=128kB --l2_size=1MB --l1d_assoc=2 \
		--l1i_assoc=2 --l2_assoc=1 --cacheline_size=64
