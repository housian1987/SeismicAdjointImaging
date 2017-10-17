#! /bin/bash

binpath=../../../bin
outpath=.
nthd=16

#-----------------------------------------------------------------------------
# Convert binary
#-----------------------------------------------------------------------------

$binpath/sjbin2su binary=vp.bin n2=501 n1=184 su=$outpath/mar_vp.su

$binpath/sjbin2su binary=vp_linear.bin n2=501 n1=184 su=$outpath/mar_init.su

#-----------------------------------------------------------------------------
# Creative survey
#-----------------------------------------------------------------------------

$binpath/sjsurvey2d ns=41 nr=482 vel=$outpath/mar_vp.su x0=0 nx=501 dx0=0 sx0=50 sz0=5 dsx=10 rx0=10 rz0=5 drx=1 drz=0  survey=$outpath/survey.su

#-----------------------------------------------------------------------------
# Simulation
#-----------------------------------------------------------------------------

mpirun -np $nthd $binpath/sjmpiawfd2d survey=$outpath/survey.su vp=$outpath/mar_vp.su profz=$outpath/recz.su nt=2501 dt=0.001 fp=5 k1=151 ycutdirect=0 amp=100000.0 

#-----------------------------------------------------------------------------
# AEI
#-----------------------------------------------------------------------------

mpirun -np $nthd $binpath/sjmpiaei2d  survey=$outpath/survey.su vp=$outpath/mar_init.su profz=$outpath/recz.su nt=2501 dt=0.001 fp=5 k1=151 ycutdirect=0 jsnap=1 niter=20 ydetails=1 izz=$outpath/ei_result.su  amp=100000.0

#-----------------------------------------------------------------------------
# AFWI
#-----------------------------------------------------------------------------

mpirun -np $nthd $binpath/sjmpiafwi2d survey=$outpath/survey.su vp=$outpath/mar_init.su profz=$outpath/recz.su nt=2501 dt=0.001 fp=5 k1=151 ycutdirect=0 jsnap=1 niter=20 ydetails=1 izz=$outpath/fwi_result.su amp=100000.0

mpirun -np $nthd $binpath/sjmpiafwi2d survey=$outpath/survey.su vp=$outpath/ei_result.su profz=$outpath/recz.su nt=2501 dt=0.001 fp=5 k1=151 ycutdirect=0 jsnap=1 niter=20 ydetails=1 izz=$outpath/ei_fwi_result.su amp=100000.0

