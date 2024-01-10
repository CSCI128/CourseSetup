function refresh-path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") +
                ";" +
                [System.Environment]::GetEnvironmentVariable("Path","User")
}

function install-python($PythonVersion, $PythonWindowsURL) {
    Write-Host "Python is not installed. Downloading $PythonVersion..."
    Invoke-WebRequest $PythonWindowsURL -OutFile "$($Env:temp)\$PythonVersion.exe"
    Write-Host "Download Complete! Installing for current user..."

    # This should install python for the current user and add it to their path. Also removes the launcher (bc it makes things confusing imo)
    Start-Process -FilePath "$($Env:temp)\$PythonVersion.exe" -ArgumentList "/passive","InstallAllUsers=0","PrependPath=1","Include_launcher=0" -Wait
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
    install-python $PythonVersion $PythonWindowsURL
}

Write-Host "Python is installed! Refreshing path..."

refresh-path

Try {
    git --version *>$null
} Catch {
    
}

if (-Not $?) {
    $exePath = "$env:TEMP\git.exe"

# Download git installer
    Invoke-WebRequest -Uri https://github.com/git-for-windows/git/releases/download/v2.37.1.windows.1/Git-2.37.1-64-bit.exe -UseBasicParsing -OutFile $exePath

# Execute git installer
    Start-Process $exePath -ArgumentList '/SILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh"' -Wait

# Optional: For bash.exe, add 'C:\Program Files\Git\bin' to PATH
    [Environment]::SetEnvironmentVariable('Path', "$([Environment]::GetEnvironmentVariable('Path', 'Machine'));C:\Program Files\Git\bin", 'Machine')

# Make new environment variables available in the current PowerShell session:
    foreach($level in "Machine","User") {
       [Environment]::GetEnvironmentVariables($level).GetEnumerator() | % {
          # For Path variables, append the new values, if they're not already in there
          if($_.Name -match 'Path$') { 
             $_.Value = ($((Get-Content "Env:$($_.Name)") + ";$($_.Value)") -split ';' | Select -unique) -join ';'
          }
          $_
       } | Set-Content -Path { "Env:$($_.Name)" }
    }

}

refresh-path

# Now for the pip packages!

# Course stuff
Write-Host "Installing class packages..."
pip install -r https://raw.githubusercontent.com/CSCI128/CourseSetup/main/requirements.txt

# Autograder stuff
# Ebic - we can do this with a web url!
Write-Host "Installing autograder pacakges..."
pip install -r https://raw.githubusercontent.com/CSCI128/128Autograder/main/source/requirements.txt


# Now for VSCode!
# VS code doesnt have a 32bit installer. Good.

Write-Host "Checking if VS Code is installed..."

$VSCodeURL = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"

Try {
    code --version *>$null
} Catch {
    # Do nothing - the error is expected
}

If (-Not $?){
    Write-Host "VS Code is not installed! Downloading VS Code..."
    Write-Host "(This might take a minute!)"
    Invoke-WebRequest $VSCodeURL -OutFile "$($Env:temp)\vscode-installer.exe"

    Write-Host "VS Code downloaded! Installing..."
    Start-Process -FilePath "$($Env:temp)\vscode-installer.exe" -ArgumentList "/SILENT","/MERGETASKS=!runcode","/SUPPRESSMSGBOXES" -Wait
}

Write-Host "VS Code is installed!"

refresh-path

Write-Host "Installing Python Extension for VS Code..."
Try {
    code --install-extension ms-python.python
} Catch {
    Write-Host "Failed to install Python Extension! Please refer to https://marketplace.visualstudio.com/items?itemName=ms-python.python to install the extension!"
}

Write-Host "Course setup is complete!"




