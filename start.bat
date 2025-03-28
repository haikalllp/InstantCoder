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

echo Starting ngrok to expose port 3000 in a new tab (requires Windows Terminal)...
REM Starts ngrok in a new Windows Terminal tab, exposing port 3000
start wt -w 0 new-tab --title Ngrok ngrok http 3000

echo Waiting 5 seconds for the server/ngrok to initialize...
REM Waits for 5 seconds without user interruption
timeout /t 5 /nobreak > nul

echo Opening browser in app mode at http://localhost:3000...
REM Get the default browser's executable path
for /f "tokens=*" %%b in ('reg query "HKEY_CLASSES_ROOT\http\shell\open\command" /ve 2^>nul ^| find /i "REG_SZ"') do set BROWSER=%%b
REM Clean up the browser path (remove quotes and arguments)
set BROWSER=%BROWSER:"=%
set BROWSER=%BROWSER:%%1=%
REM Open the default browser in app mode
start "" "%BROWSER%" --app=http://localhost:3000

echo Starting Next.js development server (npm run dev) in this tab...
REM Starts npm run dev directly in the current window/tab. This command will block further script execution here.
npm run dev

REM Note: Any commands below npm run dev might not execute until the dev server is stopped (Ctrl+C).
echo Development environment setup initiated. Check the Ngrok tab for the public URL.