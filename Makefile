.PONY: install

SETUP_SCRIPT=config_scripts/setup.sh

install:
	@chmod +x ${SETUP_SCRIPT}
	@./${SETUP_SCRIPT}

test_installation:
	@gem5/build/X86/gem5.opt gem5/tests/configs/learning-gem5-p1-simple.py
