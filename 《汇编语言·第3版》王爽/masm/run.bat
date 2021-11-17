@echo off

REM -----------------------------------
REM dos cmd demo
REM -----------------------------------

if not exist %1.asm echo "%1.asm not found"
if not exist %1.asm goto end

echo "masm.exe %1.asm"
masm.exe %1.asm;
echo "link.exe %1.asm"
link.exe %1.OBJ;
REM del %1.OBJ
REM copy %1.EXE exe\%1.exe
REM del %1.EXE

REM debug %1.EXE
@REM %1.EXE

:end