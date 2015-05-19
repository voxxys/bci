@echo off

set MATLAB=D:\R2014a

cd .

if "%1"=="" (D:\R2014a\bin\win64\gmake -f toCtest_rtw.mk all) else (D:\R2014a\bin\win64\gmake -f toCtest_rtw.mk %1)
@if errorlevel 1 goto error_exit

exit /B 0

:error_exit
echo The make command returned an error of %errorlevel%
An_error_occurred_during_the_call_to_make
