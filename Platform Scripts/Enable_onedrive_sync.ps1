# Author: Madison Durham
# GitHub: https://github.com/madison-sage-durham
# Description: This script creates or updates a registry key to enable OneDrive sync on Entra Joined devices. 
# Modify domain_guid to match your tenant's SharePoint admin center entry.
# Usage: Run with administrator privileges.
# -------------------------------------------------------
$registry_path = "HKLM:\Software\Policies\Microsoft"
$key_name = "AADJMachineDomainGuid"
$sub_path_name = "OneDrive"
$domain_guid = "CHANGEME-3E8D-4908-B814-5198AB89C51F"

# Function to create the sub-path if it does not exist.
function write_sub_path {
    New-Item -Path $registry_path -Name $sub_path_name -Force | Out-Null
}

# Function to create the key.
function write_key {
    New-ItemProperty -Path "$registry_path\$sub_path_name" -Name $key_name -Value $domain_guid -PropertyType String -Force | Out-Null
}

# Function to overwrite the key if it exists.
function overwrite_key {
    Set-ItemProperty -Path "$registry_path\$sub_path_name" -Name $key_name -Value $domain_guid -Force | Out-Null
}

# Ensure the sub-path exists.
if (-not (Test-Path -Path "$registry_path\$sub_path_name")) {
    write_sub_path
}

# Check if key exists correctly.
$existingKey = Get-ItemProperty -Path "$registry_path\$sub_path_name" -Name $key_name -ErrorAction SilentlyContinue
if (-not $existingKey) {
    write_key
} else {
    overwrite_key
}

# Validate if the key was created successfully.
$validate = Get-ItemProperty -Path "$registry_path\$sub_path_name" -Name $key_name -ErrorAction SilentlyContinue
if ($validate.$key_name -eq $domain_guid) {
    Write-Host "Registry key '$registry_path\$sub_path_name\$key_name' created/updated with value '$domain_guid' successfully."
} else {
    Write-Host "Failed to create or modify registry key '$registry_path\$sub_path_name\$key_name'."
}
