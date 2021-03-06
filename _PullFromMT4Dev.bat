rem Script to Sync Files from Development Terminal to Version Control

@echo off
setlocal enabledelayedexpansion

set SOURCE_DIR="%PATH_T2_I%"
set DEST_DIR="%PATH_DSS_Repo%\Include"

ROBOCOPY %SOURCE_DIR% %DEST_DIR% *.mqh