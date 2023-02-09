#!/bin/bash
#SBATCH --job-name=tile-sizes-job
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --nodes=6
#SBATCH --array=16-2016:64%6
#SBATCH --exclusive
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=mgltorsa@udel.edu   # Where to send mail

BINARY_FOLDER=bin
LOOP_INTER_BINARY_FOLDER=bin/loop-inter

. ./../setup.sh


TILE_SIZE=$SLURM_ARRAY_TASK_ID
#STEP=64
#for TILE_SIZE in $( eval echo {16..$MATRIX_MULT_M..$STEP})
#do
for i in {1..12..3}
do
    CORES=$i

    #Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    wait
    #vector
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/vector-multiplication/ParallelTiled "$CORES" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$CORES" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    wait
    #jacobi
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/jacobi/ParallelNonTiled "$CORES" "$CACHE" $JACOBI_M $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/jacobi/ParallelTiled "$CORES" "$CACHE" $JACOBI_M $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $BINARY_FOLDER/jacobi/ParallelSingleTiled "$CORES" "$CACHE" $JACOBI_M $TILE_SIZE
    wait

    #Loop interchange
    #LP-Matrix mult
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled "$CORES" "$CACHE" $MATRIX_MULT_M $MATRIX_MULT_M $TILE_SIZE
    wait
    #LP-vector
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelNonTiled "$CORES" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelTiled "$CORES" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelSingleTiled "$CORES" "$CACHE" $MATRIX_VECTOR_MULT_M $MATRIX_VECTOR_MULT_N $TILE_SIZE
    wait
    #LP-jacobi
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelNonTiled "$CORES" "$CACHE" $JACOBI_M $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelTiled "$CORES" "$CACHE" $JACOBI_M $TILE_SIZE
    wait
    srun --nodes=1 --ntasks=1 --cpus-per-task=$CORES --exclusive $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelSingleTiled "$CORES" "$CACHE" $JACOBI_M $TILE_SIZE
    wait
done
