::##############################################################################
:: This script is the command that is executed every run.
:: Check the examples in examples/
::
:: This script is run in the execution directory (execDir, --exec-dir).
::
:: PARAMETERS:
:: %1 is the candidate configuration number
:: %2 is the instance ID
:: %3 is the seed
:: %4 is the instance name
:: The rest (%* after `4 * SHIFT') are parameters to the run
::
:: RETURN VALUE:
:: This script should print one numerical value: the cost that must be minimized.
:: Exit with 0 if no error, with 1 in case of error
::##############################################################################

@echo off

SET "exe=python C:\TunningBRKGA\iraceBRKGA\target-runner.py"
SET "fixed_params= false -1"

FOR /f "tokens=1-4*" %%a IN ("%*") DO (
	SET candidate=%%a
	SET instance_id=%%b
	SET seed=%%c
	SET instance=%%d
	SET candidate_parameters=%%e
)

SET "stdout=c%config_id%-%instance_id%.stdout"
SET "stderr=c%config_id%-%instance_id%.stderr"

::if not exist %exe% error "%exe%: not found or not executable (pwd: %(pwd))"

:: If the program just prints a number, we can use 'exec' to avoid
:: creating another process, but there can be no other commands after exec.
::exec %exe %fixed_params% -i %instance %candidate_parameters%
:: exit 1
::
:: Otherwise, save the output to a file, and parse the result from it.
:: (If you wish to ignore segmentation faults you can use '{}' around
:: the command.)

%exe% %candidate% %instance_id% %seed% %instance% %candidate_parameters%


::if %errorlevel% neq 0 exit /b %errorlevel%

:: :: # This may be used to introduce a delay if there are filesystem
:: :: # issues.
:: :: FIXME: The following is not BAT code, so it cannot really be executed in
:: :: Windows. What is the Windows equivalent?
:: SLEEPTIME=1
:: while [ ! -s "%stdout%" ]; do
::     sleep %SLEEPTIME
::     let "SLEEPTIME += 1"
:: done
::
:: :: This is an example of reading a number from the output.
:: :: It assumes that the objective value is the first number in
:: :: the first column of the last line of the output.


:: if exist %stdout% (

:: setlocal EnableDelayedExpansion
:: set "cmd=findstr /R /N "^^" %stdout% | find /C ":""

:: for /f %%a in ('!cmd!') do set numberlines=%%a
:: set /a lastline=%numberlines%-1
:: for /f "tokens=3" %%F in ('more +%lastline% %stdout%') do set COST=%%F
:: echo %COST%
:: del %stdout% %stderr%
exit 0
 
:: ) ELSE (

:: echo "Erro. Cannot find output file"

::  exit /b
:: )
