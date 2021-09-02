@echo off
set FOLDERGOOD=0
if exist "%~dp0..\project.godot" set FOLDERGOOD=1
if exist "%~dp0..\project.binary" set FOLDERGOOD=1
if %FOLDERGOOD%==1 (
	robocopy /S "%~dp0\project_scripts" "%~dp0\.."
	del /S "%~dp0..\*.gdc"
	del /S "%~dp0..\*.gd.remap"
	echo.
	echo Script setup complete
) else (
	echo|set /p="ERROR: Parent folder doesn't seem to be a Godot project (no project.godot or project.binary)"
)
echo.
pause