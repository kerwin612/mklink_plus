@echo off

setlocal enabledelayedexpansion

set "tpath=%1"
set "lpath=%2"
set "tdisk=%tpath:~0,2%"
set "ldisk=%lpath:~0,2%"

if not exist %tpath% (
    echo [%tpath%] does not exist.
    exit /b 1
)

if exist %lpath% (
    for /d %%i in (%lpath%\*) do (
        if exist %tpath%\%%~ni (
            echo [%lpath%] already exists.
            exit /b 0
        )
    )
)

if exist %ldisk% (
    if "%tdisk%" == "%ldisk%" (
        echo [%ldisk%] already exists, and is the target disk.
    ) else (
        echo [%ldisk%] already exists, but not the target disk.
    )
) else (
    :mkmpath
    set "mpath=%TMP%\.mp.%RANDOM%.tmp"
    if exist "!mpath!" goto :mkmpath
    mkdir !mpath! & subst %ldisk% !mpath!
    echo create virtual disk [%ldisk%] mapped to [!mpath!] directory.
)

if exist %lpath% rd /s /q %lpath% >nul
mklink /j %lpath% %tpath%

endlocal
