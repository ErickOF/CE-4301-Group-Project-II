# -- an example to run SPEC 429.mcf on gem5, put it under 429.mcf folder --

export GEM5_DIR=$HOME/Documentos/Git/CE-4301-Group-Project-II/gem5
export BENCHMARK=$HOME/Documentos/Git/CE-4301-Group-Project-II/Project1_SPEC/429.mcf/src/benchmark
export ARGUMENT=$HOME/Documentos/Git/CE-4301-Group-Project-II/Project1_SPEC/429.mcf/data/inp.in
export OUTPUT_DIR=$HOME/Documentos/Git/CE-4301-Group-Project-II/Project1_SPEC/429.mcf/m5out
time $GEM5_DIR/build/X86/gem5.opt -d $OUTPUT_DIR $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o $ARGUMENT \
    -I 100000000 --cpu-type=AtomicSimpleCPU --caches --l2cache --l1d_size=128kB --l1i_size=128kB --l2_size=1MB \
    --l1d_assoc=2 --l1i_assoc=2 --l2_assoc=1 --cacheline_size=64
