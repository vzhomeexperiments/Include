rem Script to Deploy files from Version Control repository to All Terminals
rem Use when you need to publish all files to All Terminals

@echo off
setlocal enabledelayedexpansion

set SOURCE_DIR="%PATH_DSS_Repo%\Include"
set DEST_DIR1="%PATH_T1_I%"
set DEST_DIR2="%PATH_T2_I%"
set DEST_DIR3="%PATH_T3_I%"
set DEST_DIR4="%PATH_T4_I%"

ROBOCOPY %SOURCE_DIR% %DEST_DIR1% *.mqh
ROBOCOPY %SOURCE_DIR% %DEST_DIR2% *.mqh
ROBOCOPY %SOURCE_DIR% %DEST_DIR3% *.mqh
ROBOCOPY %SOURCE_DIR% %DEST_DIR4% *.mqh

