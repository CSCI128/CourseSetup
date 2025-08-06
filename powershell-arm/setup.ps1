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

$PythonVersion = "python-3.13.5"
$PythonWindowsURL = "https://www.python.org/ftp/python/3.13.5/$PythonVersion"
$PythonWindowsURL = $PythonWindowsURL + "-arm64.exe"


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

# Now for the pip packages!

# Course stuff
Write-Host "Installing class packages..."

Invoke-WebRequest https://raw.githubusercontent.com/CSCI128/CourseSetup/refs/heads/main/fonttools-4.56.0-cp313-cp313-win_arm64.whl -OutFile "$($Env:temp)\fonttools-4.56.0-cp313-cp313-win_arm64.whl"
pip install --break-system-packages "$($Env:temp)\fonttools-4.56.0-cp313-cp313-win_arm64.whl"

Invoke-WebRequest https://raw.githubusercontent.com/CSCI128/CourseSetup/refs/heads/main/numpy-2.2.4-cp313-cp313-win_arm64.whl -OutFile "$($Env:temp)\numpy-2.2.4-cp313-cp313-win_arm64.whl"
pip install --break-system-packages "$($Env:temp)\numpy-2.2.4-cp313-cp313-win_arm64.whl"

Invoke-WebRequest https://raw.githubusercontent.com/CSCI128/CourseSetup/refs/heads/main/contourpy-1.3.1-cp313-cp313-win_arm64.whl -OutFile "$($Env:temp)\contourpy-1.3.1-cp313-cp313-win_arm64.whl"
pip install --break-system-packages "$($Env:temp)\contourpy-1.3.1-cp313-cp313-win_arm64.whl"

Invoke-WebRequest https://raw.githubusercontent.com/CSCI128/CourseSetup/refs/heads/main/matplotlib-3.10.1-cp313-cp313-win_arm64.whl -OutFile "$($Env:temp)\matplotlib-3.10.1-cp313-cp313-win_arm64.whl"
pip install --break-system-packages "$($Env:temp)\matplotlib-3.10.1-cp313-cp313-win_arm64.whl"

# Autograder stuff
Write-Host "Installing 128 Autograder..."
pip install 128Autograder --break-system-packages

Write-Host "Verifing autograder intalled correctly..."

Try {
    test_my_work --version *>$null
} Catch {
    Write-Host "Failed to installed 128 Autograder"
    Write-Host "Try running 'pip install 128Autograder --break-system-packages' and the rerunning this script"
    Write-Host "Otherwise, reach out on Ed with the error above, or email Gregory Bell (gjbell@mines.edu) for help!"
    exit 1
}


# Now for VSCode!
# VS code doesnt have a 32bit installer. Good.

Write-Host "Checking if VS Code is installed..."

$VSCodeURL = "https://code.visualstudio.com/sha/download?build=stable&os=win32-arm64-user"

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




