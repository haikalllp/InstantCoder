@echo off
REM Sets the title of the command prompt window
TITLE Next.js Dev + Ngrok

echo Terminating any previous ngrok and Next.js processes...
REM Kill any running ngrok processes
taskkill /f /im ngrok.exe >nul 2>&1
REM Kill any running Node.js processes (which includes next dev)
taskkill /f /im node.exe >nul 2>&1

echo Checking dependencies...

@REM REM Check for Node.js
@REM where node > nul 2>&1
@REM if %errorlevel% neq 0 (
@REM     echo Error: Node.js is not installed or not found in PATH. Please install Node.js.
@REM     echo Error: npm is not installed or not found in PATH. Please install npm (usually included with Node.js).
@REM     pause
@REM     exit /b 1
@REM ) else (
@REM     echo Node.js found.
@REM     echo npm found.
@REM )

@REM REM Check for npm
@REM where npm > nul 2>&1
@REM if %errorlevel% neq 0 (
@REM     echo Error: npm is not installed or not found in PATH. Please install npm (usually included with Node.js).
@REM     pause
@REM     exit /b 1
@REM ) else (
@REM     echo npm found.
@REM )

REM Check for ngrok
where ngrok > nul 2>&1
if %errorlevel% neq 0 (
    echo Error: ngrok is not installed or not found in PATH. Please install ngrok and add it to your PATH.
    pause
    exit /b 1
) else (
    echo ngrok found.
)

REM Check if node_modules exists, run npm install if not
if not exist "node_modules" (
    echo node_modules directory not found. Running npm install...
    call npm install
    if %errorlevel% neq 0 (
        echo Error running npm install. Please check for errors.
        pause
        exit /b 1
    )
    echo npm install completed.
) else (
    echo node_modules directory found. Skipping npm install.
)

echo.
echo ========================================
echo Starting development environment...
echo ========================================
echo.

echo [1/3] Starting ngrok tunnel in a new tab...
REM Starts ngrok in a new Windows Terminal tab, exposing port 3000
start wt -w 0 new-tab --title Ngrok ngrok http 3000
echo       Check the Ngrok tab for your public URL to share your site.

echo [2/3] Waiting for services to initialize...
REM Waits for 5 seconds without user interruption
timeout /t 5 /nobreak > nul

echo [3/3] Opening development site in browser...
REM Try to find Chrome in common installation locations
set "CHROME_PATH=%PROGRAMFILES%\Google\Chrome\Application\chrome.exe"
if not exist "%CHROME_PATH%" set "CHROME_PATH=%PROGRAMFILES(X86)%\Google\Chrome\Application\chrome.exe"
if not exist "%CHROME_PATH%" set "CHROME_PATH=%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe"

if exist "%CHROME_PATH%" (
    echo       Opening in Chrome app mode...
    start "" "%CHROME_PATH%" --app=http://localhost:3000
) else (
    echo       Chrome not found. Opening in your default browser...
    echo       Note: For a better development experience, consider installing Chrome
    echo       to use the app mode feature.
    start http://localhost:3000
)

echo.
echo ========================================
echo Development Environment Ready!
echo ========================================
echo.
echo Local Development URL: http://localhost:3000
echo Public URL: Check the Ngrok tab (black window) for your public URL
echo.
echo Tips:
echo - Use localhost:3000 for local development
echo - Use the Ngrok URL to share your site with others
echo - Press Ctrl+C in this window to stop the development server
echo.

echo Starting Next.js development server...
REM Starts npm run dev directly in the current window/tab. This command will block further script execution here.
npm run dev

REM Note: Any commands below npm run dev might not execute until the dev server is stopped (Ctrl+C).
echo Development environment stopped. Close all windows to completely terminate the session.