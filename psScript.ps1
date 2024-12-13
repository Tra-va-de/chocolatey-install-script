# Check if the script is running with administrator rights
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Getting the path to the current script
    $scriptPath = $MyInvocation.MyCommand.Path
    # Starting a new PowerShell instance with administrative privileges
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
    Exit
}

Write-Host "The script is run with administrator privileges."

# Installing Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# List of packages to install
$currentFolder = $PSScriptRoot
$packagesFile = Join-Path -Path $currentFolder -ChildPath "chocolateyPackages.txt"
$packages = Get-Content $packagesFile

# Displaying the formatted list of packages
Write-Host "`nThe following packages will be installed:`n"
$packages | ForEach-Object { Write-Host "- $_" }

# Function to create a Voicemeeter shortcut via RunAsDate
function Create-VoicemeeterShortcut {
    # Get installation date
    $installDate = (Get-Date).ToString("dd\\MM\\yyyy HH:mm:ss")

    # Path to the Voicemeeter executable file
    $voicemeeterPath = "C:\Program Files (x86)\VB\Voicemeeter\voicemeeter8x64.exe"

    # Path to RunAsDate
    $runAsDatePath = "C:\ProgramData\chocolatey\lib\runasdate\tools\RunAsDate.exe"

    # Create a shortcut to autorun Voicemeeter via RunAsDate
    $WshShell = New-Object -ComObject WScript.Shell

    $startupShortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Voicemeeter Potato.lnk"
    $startupShortcut = $WshShell.CreateShortcut($startupShortcutPath)
    
    # Configure the autostart shortcut
    $startupShortcut.TargetPath = $runAsDatePath
    $startupShortcut.Arguments = "/movetime $installDate `"$voicemeeterPath`""
    $startupShortcut.Description = "Running Voicemeeter via RunAsDate"
    $startupShortcut.IconLocation = $voicemeeterPath  # Set the Voicemeeter icon if necessary
    
    # Save the startup shortcut
    $startupShortcut.Save()
    
    Write-Host "The autostart shortcut for Voicemeeter has been created via RunAsDate."

    # Create a shortcut on the desktop
    $desktopShortcutPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "Voicemeeter Potato.lnk")
    
    $desktopShortcut = $WshShell.CreateShortcut($desktopShortcutPath)
    
    # Configure the desktop shortcut
    $desktopShortcut.TargetPath = $runAsDatePath
    $desktopShortcut.Arguments = "/movetime $installDate `"$voicemeeterPath`""
    $desktopShortcut.Description = "Running Voicemeeter via RunAsDate"
    $desktopShortcut.IconLocation = $voicemeeterPath  # Set the Voicemeeter icon if necessary
    
    # Save the desktop shortcut
    $desktopShortcut.Save()
    
    Write-Host "The shortcut for launching Voicemeeter has been created on the desktop."
}

# Function to restore a Voicemeeter settings
function Restore-VoicemeeterSettings {
    # Define the path for Voicemeeter settings
    $voicemeeterSettingsPath = "$env:APPDATA\VoiceMeeterPotatoDefault.xml"

    # Get the directory of the current script
    $scriptDirectory = $PSScriptRoot

    # Define the backup file path in the same directory as the script
    $backupFilePath = Join-Path -Path $scriptDirectory -ChildPath "VoiceMeeterPotatoDefault.xml"

    # Write-Host $voicemeeterSettingsPath
    # Write-Host $scriptDirectory
    # Write-Host $backupFilePath

    # Restore settings (uncomment to use)
    Copy-Item -Path $backupFilePath -Destination $voicemeeterSettingsPath -Force

    Write-Host "Voicemeeter settings restore completed."
}

# Asking for confirmation to install all packages
$packagesConfirmation = Read-Host -Prompt "`nDo you want to install these packages? [Y]es or [N]o"

if ($packagesConfirmation -eq 'Y' -or $packagesConfirmation -eq '') {  # Default to Yes on Enter
    foreach ($package in $packages) {
        choco install -y $package
        Write-Host "$package has been installed."
    }

    # Check if the Voicemeeter package is available
    $hasVoicemeeterPotato = Get-Package | Where-Object { $_.Id -eq 'voicemeeter-potato' }

    if ($hasVoicemeeterPotato) {
        Restore-VoicemeeterSettings  # Restore settings if voicemeeter-potato is present

        # Check if the RunAsDate package is available
        $hasRunAsDate = Get-Package | Where-Object { $_.Id -eq 'runasdate' }
        if ($hasRunAsDate) {
            Create-VoicemeeterShortcut  # Create shortcut if both voicemeeter-potato and runasdate are present
        }
    }
} else {
    Write-Host "Installation of packages skipped."
}

# Asking for confirmation to install all packages
$licenseConfirmation = Read-Host -Prompt "`nDo you want to activate Windows? [Y]es or [N]o"

if ($licenseConfirmation -eq 'Y' -or $licenseConfirmation -eq '') {  # Default to Yes on Enter
    irm https://get.activated.win | iex
} else {
    Write-Host "Windows activation has been skipped."
}

# Waiting for user input before exiting
Read-Host -Prompt "`nPress Enter to exit"