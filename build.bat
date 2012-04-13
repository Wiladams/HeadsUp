@rem Script to build LuaJIT with MSVC.
@rem Copyright (C) 2005-2011 Mike Pall. See Copyright Notice in luajit.h
@rem
@rem Either open a "Visual Studio .NET Command Prompt"
@rem (Note that the Express Edition does not contain an x64 compiler)
@rem -or-
@rem Open a "Windows SDK Command Shell" and set the compiler environment:
@rem     setenv /release /x86
@rem   -or-
@rem     setenv /release /x64
@rem
@rem Then cd to this directory and run this script.

@if not defined INCLUDE goto :FAIL

@setlocal
@set LJCOMPILE=cl /nologo /c /MD /O2 /W3 /D_CRT_SECURE_NO_DEPRECATE
@set LJLINK=link /nologo
@set LJMT=mt /nologo
@set LJLIB=lib /nologo
@set DASMDIR=..\dynasm
@set DEPSDIR=..\deps
@set DASM=lua %DASMDIR%\dynasm.lua


%LJCOMPILE% HeadsUpMain.cpp

@if errorlevel 1 goto :BAD

@rem  The secret to building something that does not bring up
@rem a console window upon launch is to use
@rem the /SUBSYSTEM:WINDOWS flag with the linker
%LJLINK% /out:HeadsUp.exe HeadsUpMain.obj objs\lua51.lib gdi32.lib user32.lib kernel32.lib opengl32.lib
@rem %LJLINK% /SUBSYSTEM:WINDOWS /out:HeadsUp.exe HeadsUpMain.obj objs\lua51.lib gdi32.lib user32.lib kernel32.lib opengl32.lib


@rem @del *.obj *.manifest buildvm.exe
@echo.
@echo === Successfully built WLuaJIT ===

@goto :END
:BAD
@echo.
@echo *******************************************************
@echo *** Build FAILED -- Please check the error messages ***
@echo *******************************************************
@goto :END
:FAIL
@echo You must open a "Visual Studio .NET Command Prompt" to run this script
:END
