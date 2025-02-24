# Author: Madison Durham
# GitHub: https://github.com/madison-sage-durham
# Description: This script pulls the latest FortinetClient VPN Online Installer.
# Usage: Run with administrator privileges.
# -------------------------------------------------------

# Define URL, destination, and arguments.
$url = "https://filestore.fortinet.com/forticlient/FortiClientVPNOnlineInstaller.exe"
$out_path = "$PSScriptRoot/FortiClientVPNOnlineInstaller.exe"
$args_list = "/quiet /norestart /uninstallfamilys"
# Download the file
Invoke-WebRequest -Uri $url -OutFile $out_path -ArgumentList 


# Install the program
Start-Process -Filepath "$out_path" -ArgumentList "$args_list"

# Schedule config import

# Define the task name
$task_name = "FortiClientVPNOnlineInstallerConfigImport"

# Define the executable path and arguments
$exe_path = "C:\Program Files\Fortinet\FortiClient\fcconfig.exe"
$config_path ="$PSScriptRoot\vpn.sconf"
# This method should be improved before adoption in your environment.
$encrypted_password = "notsecure"
$arguments = "-q -m vpn -f $config_path -o import -p $encrypted_password"       

# Create a new task trigger to run at startup
$trigger = New-ScheduledTaskTrigger -AtStartup

# Define task action to run the executable with arguments
$action = New-ScheduledTaskAction -Execute $exePath -Argument $arguments

# Set task settings to delete the task after running once
$settings = New-ScheduledTaskSettingsSet -DeleteExpiredTaskAfter (New-TimeSpan -Minutes 1) -AllowStartIfOnBatteries

# Register the task to run once at startup and delete itself after execution
Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Settings $settings -RunLevel Highest -User "SYSTEM"

Write-Host "Scheduled $exePath to run once at next startup and delete itself after execution."
