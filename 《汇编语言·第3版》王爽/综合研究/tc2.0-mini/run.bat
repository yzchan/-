@echo off

REM -----------------------------------
REM dos cmd demo
REM -----------------------------------

if not exist %1.c echo "%1.c not found"
if not exist %1.c goto end

echo "tcc.exe -LLIB %1.c"
tcc.exe -LLIB %1.c

:end