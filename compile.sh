#!/bin/bash

BINARY_FOLDER=bin
LOOP_INTER_BINARY_FOLDER=bin/loop-inter
PROJECT_EXTRA="-lm"

mkdir $BINARY_FOLDER
mkdir $LOOP_INTER_BINARY_FOLDER

mkdir $BINARY_FOLDER/matrix-multiplication
mkdir $BINARY_FOLDER/vector-multiplication
mkdir $BINARY_FOLDER/jacobi


mkdir $LOOP_INTER_BINARY_FOLDER/matrix-multiplication
mkdir $LOOP_INTER_BINARY_FOLDER/vector-multiplication
mkdir $LOOP_INTER_BINARY_FOLDER/jacobi

#Matrix
gcc -g -fopenmp matrix-multiplication/ParallelNonTiled.c -o $BINARY_FOLDER/matrix-multiplication/ParallelNonTiled $PROJECT_EXTRA
gcc -g -fopenmp matrix-multiplication/ParallelTiled.c -o $BINARY_FOLDER/matrix-multiplication/ParallelTiled $PROJECT_EXTRA
gcc -g -fopenmp matrix-multiplication/ParallelSingleTiled.c -o $BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled $PROJECT_EXTRA

# #Vector
gcc -g -fopenmp vector-multiplication/ParallelNonTiled.c -o $BINARY_FOLDER/vector-multiplication/ParallelNonTiled $PROJECT_EXTRA
gcc -g -fopenmp vector-multiplication/ParallelTiled.c -o $BINARY_FOLDER/vector-multiplication/ParallelTiled $PROJECT_EXTRA
gcc -g -fopenmp vector-multiplication/ParallelSingleTiled.c -o $BINARY_FOLDER/vector-multiplication/ParallelSingleTiled $PROJECT_EXTRA


# #Jacobi
gcc -g -fopenmp jacobi/ParallelNonTiled.c -o $BINARY_FOLDER/jacobi/ParallelNonTiled $PROJECT_EXTRA
gcc -g -fopenmp jacobi/ParallelTiled.c -o $BINARY_FOLDER/jacobi/ParallelTiled $PROJECT_EXTRA
gcc -g -fopenmp jacobi/ParallelSingleTiled.c -o $BINARY_FOLDER/jacobi/ParallelSingleTiled $PROJECT_EXTRA



#loop inter

#Matrix
gcc -g -fopenmp loop_inter_tiling/matrix-multiplication/ParallelNonTiled.c -o $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelNonTiled $PROJECT_EXTRA
gcc -g -fopenmp loop_inter_tiling/matrix-multiplication/ParallelTiled.c -o $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelTiled $PROJECT_EXTRA
gcc -g -fopenmp loop_inter_tiling/matrix-multiplication/ParallelSingleTiled.c -o $LOOP_INTER_BINARY_FOLDER/matrix-multiplication/ParallelSingleTiled $PROJECT_EXTRA

#Vector
gcc -g -fopenmp loop_inter_tiling/vector-multiplication/ParallelNonTiled.c -o $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelNonTiled $PROJECT_EXTRA
gcc -g -fopenmp loop_inter_tiling/vector-multiplication/ParallelTiled.c -o $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelTiled $PROJECT_EXTRA
gcc -g -fopenmp loop_inter_tiling/vector-multiplication/ParallelSingleTiled.c -o $LOOP_INTER_BINARY_FOLDER/vector-multiplication/ParallelSingleTiled $PROJECT_EXTRA


#Jacobi
gcc -g -fopenmp loop_inter_tiling/jacobi/ParallelNonTiled.c -o $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelNonTiled $PROJECT_EXTRA
gcc -g -fopenmp loop_inter_tiling/jacobi/ParallelTiled.c -o $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelTiled $PROJECT_EXTRA
gcc -g -fopenmp loop_inter_tiling/jacobi/ParallelSingleTiled.c -o $LOOP_INTER_BINARY_FOLDER/jacobi/ParallelSingleTiled $PROJECT_EXTRA
