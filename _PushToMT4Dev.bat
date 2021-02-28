rem Script to Deploy files from Version Control repository to Development Terminal
rem Use in case some content needs to be replaced (reverted from Version Control History)

@echo off
setlocal enabledelayedexpansion

set SOURCE_DIR="%PATH_DSS_Repo%\Include"
set DEST_DIR="%PATH_T2_I%"

ROBOCOPY %SOURCE_DIR% %DEST_DIR% *.mqh

pause