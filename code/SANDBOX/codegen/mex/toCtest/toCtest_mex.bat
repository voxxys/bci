@echo off
set MATLAB=D:\R2014a
set MATLAB_ARCH=win64
set MATLAB_BIN="D:\R2014a\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=.\
set LIB_NAME=toCtest_mex
set MEX_NAME=toCtest_mex
set MEX_EXT=.mexw64
call "D:\R2014a\sys\lcc64\lcc64\mex\lcc64opts.bat"
echo # Make settings for toCtest > toCtest_mex.mki
echo COMPILER=%COMPILER%>> toCtest_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> toCtest_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> toCtest_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> toCtest_mex.mki
echo LINKER=%LINKER%>> toCtest_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> toCtest_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> toCtest_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> toCtest_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> toCtest_mex.mki
echo BORLAND=%BORLAND%>> toCtest_mex.mki
echo OMPFLAGS= >> toCtest_mex.mki
echo OMPLINKFLAGS= >> toCtest_mex.mki
echo EMC_COMPILER=lcc64>> toCtest_mex.mki
echo EMC_CONFIG=optim>> toCtest_mex.mki
"D:\R2014a\bin\win64\gmake" -B -f toCtest_mex.mk
