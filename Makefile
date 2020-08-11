.PONY: setup_gem5 setup_parsec test_gem5 test_parsec

SETUP_GEM5_SCRIPT=config_scripts/setup_gem5.sh
SETUP_PARSEC_SCRIPT=config_scripts/setup_parsec.sh


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
