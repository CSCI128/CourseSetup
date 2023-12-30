function refresh-path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") +
                ";" +
                [System.Environment]::GetEnvironmentVariable("Path","User")
}

$PythonVersion = "python-3.11.7"
$PythonWindowsURL = "https://www.python.org/ftp/python/3.11.7/$PythonVersion"

If ((Get-CimInStance Win32_OperatingSystem).OSArchitecture -eq "64-Bit"){
    Write-Host "Detected 64 bit operating system"

    $PythonWindowsURL = $PythonWindowsURL + "-amd64.exe"
}
Else {
    # I swear if anyone has a 32 os imma cry
    Write-Host "Detected 32 bit operating system"
    $PythonWindowsURL = $PythonWindowsURL + ".exe"
}


Write-Host "Detecting if python is already installed..."

# Also putting this in a try catch if students have disabled the default behavior on windows

Try{
    python --version *>$null
} Catch {
    # Suppress error as its expected
}

If (-Not $?) {
    Write-Host "Python is not installed. Downloading $PythonVersion..."
    Invoke-WebRequest $PythonWindowsURL -OutFile "$($Env:temp)\$PythonVersion.exe"
    Write-Host "Download Complete! Installing for current user..."

    # This should install python for the current user and add it to their path. Also removes the launcher (bc it makes things confusing imo)
    Start-Process -FilePath "$($Env:temp)\$PythonVersion.exe" -ArgumentList "/passive","InstallAllUsers=0","PrependPath=1","Include_launcher=0" -Wait
}

Write-Host "Python is installed! Refreshing path..."

refresh-path


# Now for the pip packages!

# Course stuff
Write-Host "Installing class packages..."
pip install matplotlib

# Autograder stuff
# Ebic - we can do this with a web url!
Write-Host "Installing autograder pacakges..."
pip install -r https://raw.githubusercontent.com/CSCI128/128Autograder/main/source/requirements.txt


# Now for VSCode!
# VS code doesnt have a 32bit installer. Good.

Write-Host "Checking if VS Code is installed"

$VSCodeURL = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"

Try {
    code --version *>$null
} Catch {
    # Do nothing - the error is expected
}

If (-Not $?){
    Write-Host "VS Code is not installed! Downloading VS Code..."
    Invoke-WebRequest $VSCodeURL -OutFile "$($Env:temp)\vscode-installer.exe"

    Write-Host "VS Code downloaded! Installing..."
    Start-Process -FilePath "$($Env:temp)\vscode-installer.exe" -ArgumentList "/SILENT","/MERGETASKS=!runcode","/SUPPRESSMSGBOXES" -Wait
}

Write-Host "VS Code is installed! Course setup complete!"




