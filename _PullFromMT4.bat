rem Script to Sync Files from Development Terminal to Version Control

@echo off
setlocal enabledelayedexpansion

set SOURCE_DIR="C:\Program Files (x86)\FxPro - Terminal2\MQL4\Include"
set DEST_DIR="C:\Users\fxtrams\Documents\000_TradingRepo\Include"

ROBOCOPY %SOURCE_DIR% %DEST_DIR% *.mqh