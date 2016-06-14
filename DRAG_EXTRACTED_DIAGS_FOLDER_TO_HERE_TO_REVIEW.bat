@echo off
Mode Con Cols=150
set PATH=%~dp004_CYGWIN\cygwin\bin;%PATH%;%~dp0
set CYGWIN=nodosfilewarning

cls
CALL extractor.bat %1 
bash %~dp0rma_log_review.sh %1
IF [%2]==[] GOTO END
CALL extractor.bat %2
bash %~dp0rma_log_review.sh %2
IF [%3]==[] GOTO END
CALL extractor.bat %3
bash %~dp0rma_log_review.sh %3
IF [%4]==[] GOTO END
CALL extractor.bat %4
bash %~dp0rma_log_review.sh %4
IF [%5]==[] GOTO END
CALL extractor.bat %5
bash %~dp0rma_log_review.sh %5
IF [%6]==[] GOTO END
CALL extractor.bat %6
bash %~dp0rma_log_review.sh %6
IF [%7]==[] GOTO END
CALL extractor.bat %7
bash %~dp0rma_log_review.sh %7
IF [%8]==[] GOTO END
CALL extractor.bat %8
bash %~dp0rma_log_review.sh %8
IF [%9]==[] GOTO END
CALL extractor.bat %9
bash %~dp0rma_log_review.sh %9
:END
pause