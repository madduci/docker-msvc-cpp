@echo off

set CONAN_REVISIONS_ENABLED=1
set CONAN_USE_ALWAYS_SHORT_PATHS=1
set CONAN_NON_INTERACTIVE=1

set CMAKE_GENERATOR=Ninja

set ExtensionSdkDir=C:\Tools\SDK\10\ExtensionSDKs
set INCLUDE=C:\Tools\VS2022\VC\Tools\MSVC\14.38.33130\include;C:\Tools\VS2022\VC\Tools\MSVC\14.38.33130\ATLMFC\include;C:\Tools\VS2022\VC\Auxiliary\VS\include;C:\Tools\SDK\10\include\10.0.20348.0\ucrt;C:\Tools\SDK\10\include\10.0.20348.0\um;C:\Tools\SDK\10\include\10.0.20348.0\shared;C:\Tools\SDK\10\include\10.0.20348.0\\winrt;C:\Tools\SDK\10\include\10.0.20348.0\cppwinrt
set LIB=C:\Tools\VS2022\VC\Tools\MSVC\14.38.33130\ATLMFC\lib\x64;C:\Tools\VS2022\VC\Tools\MSVC\14.38.33130\lib\x64;C:\Tools\SDK\10\lib\10.0.20348.0\ucrt\x64;C:\Tools\SDK\10\\lib\10.0.20348.0\um\x64
set LIBPATH=C:\Tools\VS2022\VC\Tools\MSVC\14.38.33130\ATLMFC\lib\x64;C:\Tools\VS2022\VC\Tools\MSVC\14.38.33130\lib\x64;C:\Tools\VS2022\VC\Tools\MSVC\14.38.33130\lib\x64\store\references;C:\Tools\SDK\10\UnionMetadata\10.0.20348.0;C:\Tools\SDK\10\References\10.0.20348.0
set PATH=C:\Tools\Git\cmd;C:\Tools\Conan\conan;C:\Tools\CMake\bin;C:\Tools\Wix;C:\Tools\Ninja;C:\Tools\VS2022\VC\Tools\MSVC\14.38.33130\bin\HostX64\x64;C:\Tools\SDK\10\bin\10.0.20348.0\x64;C:\Tools\SDK\10\bin\x64;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;
set PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC
set Platform=x64
set PROCESSOR_ARCHITECTURE=AMD64
set UCRTVersion=10.0.20348.0
set UniversalCRTSdkDir=C:\Tools\SDK\10\
set VS170COMNTOOLS=C:\Tools\Common7\Tools\
set VCINSTALLDIR=C:\Tools\VS2022\VC\
set VCToolsInstallDir=C:\Tools\VS2022\VC\Tools\MSVC\14.38.33130\
set VCToolsRedistDir=C:\Tools\VS2022\VC\Redist\MSVC\14.38.33130\
set VCToolsVersion=14.38.33130
set VisualStudioVersion=17.0
set VSCMD_ARG_app_plat=Desktop
set VSCMD_ARG_HOST_ARCH=x64
set VSCMD_ARG_TGT_ARCH=x64
set VSCMD_VER=17.8.5
set VSINSTALLDIR=C:\Tools\
set WindowsLibPath=C:\Tools\SDK\10\UnionMetadata\10.0.20348.0;C:\Tools\SDK\10\References\10.0.20348.0
set WindowsSdkBinPath=C:\Tools\SDK\10\bin\
set WindowsSdkDir=C:\Tools\SDK\10\
set WindowsSDKLibVersion=10.0.20348.0\
set WindowsSdkVerBinPath=C:\Tools\SDK\10\bin\10.0.20348.0\
set WindowsSDKVersion=10.0.20348.0\
set __DOTNET_ADD_64BIT=1
set __DOTNET_PREFERRED_BITNESS=64