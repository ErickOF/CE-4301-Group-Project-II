.PONY: setup_gem5 setup_parsec test_gem5 test_parsec

SETUP_GEM5_SCRIPT=config_scripts/setup_gem5.sh
SETUP_PARSEC_SCRIPT=config_scripts/setup_parsec.sh
DEBUG_DIR=project/debug_out
M5OUT_DIR=m5out


setup_gem5:
	@chmod +x ${SETUP_GEM5_SCRIPT}
	@./${SETUP_GEM5_SCRIPT}

setup_parsec:
	@chmod +x ${SETUP_PARSEC_SCRIPT}
	@./${SETUP_PARSEC_SCRIPT}

test_gem5:
	@gem5/build/X86/gem5.opt gem5/tests/configs/learning-gem5-p1-simple.py

test_parsec:
	@echo ""

test_example:
	@gem5/build/X86/gem5.opt project/test.py

run_project_test1:
	@gem5/build/X86/gem5.opt --debug-flags=Cache project/project.py --l1pf A --l1rp A --l1ll A --l1a 2 \
			--l2pf B --l2rp B --l2ll B --l2a 8 >> ${DEBUG_DIR}/tb_result1.txt
	#@cat ${DEBUG_DIR}/tb_result1.txt
	@mv ${M5OUT_DIR}/* ${DEBUG_DIR}

run_project_test:
	@gem5/build/X86/gem5.opt project/project.py --l1pf A --l1rp A --l1ll 2 --l1a 2 \
			--l2pf B --l2rp B --l2ll 20 --l2a 8
	#@cat ${DEBUG_DIR}/tb_result1.txt
	@mv ${M5OUT_DIR}/* ${DEBUG_DIR}
