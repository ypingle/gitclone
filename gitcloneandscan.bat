@echo off
REM Define variables
set "GIT_USER=admin"
set "GIT_PASSWORD=admin"
set "GIT_URL=http://%GIT_USER%:%GIT_PASSWORD%@ec2-35-167-1-96.us-west-2.compute.amazonaws.com/Bonobo.Git.Server/test1.git"
set "CX_SERVER=http://ec2-35-167-1-96.us-west-2.compute.amazonaws.com"
set "CX_USER=admin"
set "CX_PASSWORD=Aa12345678!"
set "PROJECT_NAME=CxServer"
set "PROJECTS_ROOT=C:\projects"
set "CXCONSOLE_PATH=C:\Users\Yoel\Downloads\CxConsolePlugin-1.1.30"

REM Extract the repository name from GIT_URL and remove the '.git' extension
for %%i in ("%GIT_URL:*.git=%") do set "REPO_URL_PATH=%%~nxi"
set "REPO_NAME=%REPO_URL_PATH:.git=%"

REM Construct LOCATION_PATH
set "LOCATION_PATH=%PROJECTS_ROOT%\%REPO_NAME%"

REM Concatenate REPO_NAME to PROJECT_NAME
set "FULL_PROJECT_NAME=%PROJECT_NAME%\%REPO_NAME%"

REM Navigate to the project directory
cd /d %PROJECTS_ROOT%

REM Check if the repository folder exists and delete it if it does
if exist "%LOCATION_PATH%" (
    echo Deleting existing repository folder: %LOCATION_PATH%
    rmdir /s /q "%LOCATION_PATH%"
)

REM Clone the Git repository using the variable
git clone "%GIT_URL%"

REM Navigate to the CxConsole Plugin directory
cd /d "%CXCONSOLE_PATH%"

REM Run the CxConsole Scan
.\runCxConsole Scan -CxServer "%CX_SERVER%" -ProjectName "%FULL_PROJECT_NAME%" -CxUser "%CX_USER%" -CxPassword "%CX_PASSWORD%" -locationtype folder -locationpath "%LOCATION_PATH%"

