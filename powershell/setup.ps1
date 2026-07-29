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

Write-Host "Detecting if git is already installed..."

refresh-path

# Now for the pip packages!

# Course stuff
Write-Host "Installing class packages..."
pip install -r https://raw.githubusercontent.com/CSCI128/CourseSetup/main/requirements.txt --break-system-packages

# Autograder stuff
Write-Host "Installing 128 Autograder..."
pip install 128Autograder --break-system-packages

Write-Host "Verifing autograder installed correctly..."

Try {
    test_my_work --version *>$null
} Catch {
    Write-Host "Failed to installed 128 Autograder"
    Write-Host "Try running 'pip install 128Autograder --break-system-packages' and the rerunning this script"
    Write-Host "Otherwise, reach out on Ed with the error above for help!"
    exit 1
}


# Now for VSCodium!
# VSCodium doesnt have a 32bit installer. Good.

Write-Host "Checking if VSCodium is installed..."

$VSCodeURL = "https://github.com/VSCodium/vscodium/releases/download/1.126.04524/VSCodiumUserSetup-x64-1.126.04524.exe"

Try {
    codium --version *>$null
} Catch {
    # Do nothing - the error is expected
}

If (-Not $?){
    Write-Host "VSCodium is not installed! Downloading VSCodium..."
    Write-Host "(This might take a minute!)"
    Invoke-WebRequest $VSCodeURL -OutFile "$($Env:temp)\codium-installer.exe"

    Write-Host "VSCodium downloaded! Installing..."
    Start-Process -FilePath "$($Env:temp)\codium-installer.exe" -ArgumentList "/SILENT","/MERGETASKS=!runcode","/SUPPRESSMSGBOXES" -Wait
}

Write-Host "VSCodium is installed!"

refresh-path

Write-Host "Installing Python Extension for VSCodium..."
Try {
    codium --install-extension ms-python.python
} Catch {
    Write-Host "Failed to install Python Extension! Please run VSCodium and install the Python extension manually"
}

Write-Host "Course setup is complete!"




