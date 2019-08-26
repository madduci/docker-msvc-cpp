############################################
#
# Author; Michele Adduci
# Copyright 2019. All rights reserved 
#
# Powershell script to download and install automatically
# Visual C++ 2019 tools, CMake, Conan, WIX and Ninja
#
############################################

####################################
# Define Variables
####################################
$start_time = Get-Date
# Define where to download all the installers required
$working_directory = "$env:temp"
$packages_directory = "C:\Packages"

####################################
# Define CMake information
####################################
$cmake_version = "3.15.2"
$cmake_platform = "win64-x64"
$cmake_installer_url = "https://github.com/Kitware/CMake/releases/download/v$cmake_version/cmake-$cmake_version-$cmake_platform.msi"
$cmake_installer_msi = "$working_directory\cmake.msi"
$cmake_install_path = "C:\Program Files\CMake"
$cmake_zip_output_path = "$packages_directory\CMake"

####################################
# Define Conan information
####################################
$conan_version = "win-64_1_18_1"
$conan_installer_url = "https://dl.bintray.com/conan/installers/conan-$conan_version.exe"
$conan_installer_exe = "$working_directory\conan.exe"
$conan_install_path = "C:\Program Files\Conan"
$conan_zip_output_path = "$packages_directory\Conan"

####################################
# Define WIX information
####################################
$wix_version = "311"
$wix_binaries_url = "https://github.com/wixtoolset/wix3/releases/download/wix3111rtm/wix311-binaries.zip"
$wix_binaries = "$working_directory\wix.zip"
$wix_install_path = "C:\Program Files\WIX"
$wix_zip_output_path = "$packages_directory\WIX.zip"

####################################
# Define Ninja information
####################################
$ninja_version = "1.9.0"
$ninja_binaries_url = "https://github.com/ninja-build/ninja/releases/download/v$ninja_version/ninja-win.zip"
$ninja_binaries = "$working_directory\ninja.zip"
$ninja_install_path = "C:\Program Files\Ninja"
$ninja_zip_output_path = "$packages_directory\Ninja.zip"

####################################
# Define Visual Studio information
####################################

# Checkout Visual Studio Components
# https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-build-tools?vs-2019&view=vs-2019

# VS2019 Community Edition
$vs_installer_url = "https://download.visualstudio.microsoft.com/download/pr/7b196ac4-65a9-4fde-b720-09b5339dbaba/78df39539625fa4e6c781c6a2aca7b4f/vs_community.exe"
$vs_installer_exe = "$working_directory\vs_community.exe"
$vs_install_path = "C:\vs2019"
$windows_sdk_version_major = "10"
$windows_sdk_version_minor = "18362"

# Define all the desired components
$module_msbuild = "Microsoft.Component.MSBuild"
$module_native_desktop = "Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Core"
$module_compilerx86 = "Microsoft.VisualStudio.Component.VC.Tools.x86.x64"
$module_vcredist ="Microsoft.VisualStudio.Component.VC.Redist.14.Latest"
$module_atl = "Microsoft.VisualStudio.Component.VC.ATL"
$module_atlfmfc = "Microsoft.VisualStudio.Component.VC.ATLMFC"
$module_sdk = "Microsoft.VisualStudio.Component.Windows10SDK.$windows_sdk_version_minor"
# Wait until the completion of the installer, do not restart the machine, don't show UI
$vs_silent_args = "--quiet --wait --norestart"
# Defining where Visual C/C++ tools are installed
$visualc_path = "$vs_install_path\VC"
# Defining where Windows SDK is installed
$windows_sdk_path = "C:\Program Files (x86)\Windows Kits\$windows_sdk_version_major"
# Defining output path for archiving Visual C/C++ and Windows SDK
$vc_zip_output_path = "$packages_directory\VC2019"
$sdk_zip_output_path = "$packages_directory\SDK"

####################################
# Create Folder to store packages
####################################

New-Item $packages_directory -ItemType directory

####################################
# Prepare Visual Studio Package
####################################

Write-Host "Downloading Visual Studio 2019 Community Edition"
Invoke-WebRequest -Uri "$vs_installer_url" -OutFile "$vs_installer_exe"

Write-Host "Installing C++ Development Environment"
Start-Process -FilePath "$vs_installer_exe" -Wait -ArgumentList "$vs_silent_args --installPath `"$vs_install_path`" --add $module_msbuild --add $module_vcredist --add $module_native_desktop --add $module_sdk --add $module_atlfmfc --add $module_atl --add $module_compilerx86";

Write-Host "Compressing Visual C++ files in an archive"
Compress-Archive -Path "$visualc_path" -DestinationPath "$vc_zip_output_path"

Write-Host "Compressing Windows $windows_sdk_version_major-$windows_sdk_version_minor SDK files in an archive"
Compress-Archive -Path "$windows_sdk_path" -DestinationPath "$sdk_zip_output_path"

####################################
# Prepare Conan Package
####################################

Write-Host "Downloading Conan $conan_version"
Invoke-WebRequest -Uri "$conan_installer_url" -OutFile "$conan_installer_exe"

Write-Host "Installing Conan"
Start-Process -FilePath "$conan_installer_exe" -Wait -ArgumentList "/VERYSILENT /SUPPRESSMSGBOXES";

Write-Host "Compressing Conan files in an archive"
Compress-Archive -Path "$conan_install_path" -DestinationPath "$conan_zip_output_path"

####################################
# Prepare CMake Package
####################################

Write-Host "Downloading CMake $cmake_version-$cmake_platform"
Invoke-WebRequest -Uri "$cmake_installer_url" -OutFile "$cmake_installer_msi"

Write-Host "Installing CMake"
Start-Process -FilePath "msiexec" -Wait -ArgumentList "/i `"$cmake_installer_msi`" /qn /norestart";

Write-Host "Compressing CMake files in an archive"
Compress-Archive -Path "$cmake_install_path" -DestinationPath "$cmake_zip_output_path"

####################################
# Prepare WIX Package
####################################
    
Write-Host "Downloading WIX $wix_version"
Invoke-WebRequest -Uri "$wix_binaries_url" -OutFile "$wix_binaries"

Write-Host "Extracting WIX Binaries into $wix_install_path"
Expand-Archive -LiteralPath "$wix_binaries" -DestinationPath "$wix_install_path"

Write-Host "Adding Wix to the environment Path"
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";$wix_install_path",
    [EnvironmentVariableTarget]::Machine)

Write-Host "Copying WIX Binaries archive to the output folder"
Copy-Item $wix_binaries -Destination "$wix_zip_output_path"

####################################
# Prepare Ninja Package
####################################
    
Write-Host "Downloading Ninja $ninja_version"
Invoke-WebRequest -Uri "$ninja_binaries_url" -OutFile "$ninja_binaries"

Write-Host "Extracting Ninja Binaries into $ninja_install_path"
Expand-Archive -LiteralPath "$ninja_binaries" -DestinationPath "$ninja_install_path"

Write-Host "Adding Ninja to the environment Path"
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";$ninja_install_path",
    [EnvironmentVariableTarget]::Machine)

Write-Host "Copying Ninja Binaries archive to the output folder"
Copy-Item $ninja_binaries -Destination "$ninja_zip_output_path"

####################################
# Cleanup
####################################

Write-Host "Removing downloaded installers/packages"
Remove-Item -Path "$wix_binaries" -Force
Remove-Item -Path "$cmake_installer_msi" -Force
Remove-Item -Path "$conan_installer_exe" -Force
Remove-Item -Path "$vs_installer_exe" -Force

Write-Output "Setup completed. Time taken: $((Get-Date).Subtract($start_time).Minutes) minute(s)"