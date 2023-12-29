$PythonVersion = "python-3.11.7"
$PythonWindowsURL = "https://www.python.org/ftp/python/3.11.7/$PythonVersion"

If ((Get-CimInStance Win32_OperatingSystem).OSArchitecture -eq "64-Bit"){
    Write-Host "Detected 64 bit operating system, if you have an ARM windows computer, first off, why? and second, download the ARM version at python.org"

    $PythonWindowsURL = $PythonWindowsURL + "-amd64.exe"
}
Else {
    # I swear if anyone has a 32 os imma cry
    Write-Host "Detected 32 bit operating system, if you have an ARM windows computer, first off, why? and second, download the ARM version at python.org"
    $PythonWindowsURL = $PythonWindowsURL + ".exe"
}


Write-Host "Detecting if python is already installed..."

python --version

If (-Not $?) {
    Write-Host "Python is not installed. Installing $PythonVersion..."
    Invoke-WebRequest $PythonWindowsURL -OutFile "$($Env:temp)\$PythonVersion.exe"
    Write-Host "Download Complete! Installing for current user..."

    # This should install python for the current user and add it to their path. Also removes the launcher (bc it makes things confusing imo)
    Start-Process -FilePath "$($Env:temp)\$PythonVersion.exe" -ArgumentList "/passive","InstallAllUsers=0","PrependPath=1","Include_launcher=0"
}
