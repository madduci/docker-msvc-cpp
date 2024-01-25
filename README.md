# docker-msvc-cpp

This is a reproducible Linux-based Dockerfile for cross compiling with MSVC compiler, Conan, CMake, Ninja and Wix Toolset, usable as base image for Continuous Integration setups.

This requires a zipped package of a real MSVC installation from Windows
(currently only supporting MSVC 2019, tested until latest 16.11.2), which isn't freely redistributable, so you have to build it on your own.

The MSVC installation can be performed using a Vagrant box and executing the installation of MSVC Community Edition: a Vagrantfile and a Powershell script to prepare the require packages are included in this repository.

## Requirements

### Hardware 

* Dual-Core CPU, with VT-x/AMD-v enabled
* 8 GByte RAM (16 GByte recommended)
* Enough Disk Space for Vagrant and Docker images (50 GByte free recommended)
* Fast internet connection

### Software

* Virtualbox (7.x)
* Vagrant (2.x)
* Docker Engine 20+
* Docker-Compose 1.20+

#### Vagrant Plugins

* winrm 
* winrm-elevated

## Build

To build the docker image, you need to run the following commands:

```
# starts the Vagrant box, installs MSVC and the other tools and prepares the zip packages
./download-tools.sh
# Builds the docker images (the Ubuntu 22.04 image with wine and the one including also the tools)
./build-docker-images.sh
```

The first script will start a Vagrant/Virtualbox Virtual Machine with Windows 10, which will execute an unattended installation of Visual C++ tools, together with CMake, Conan and Wix Toolset. Once the installation is completed, the required files will be compressed in ZIP archives and put on the host machine.

The second script will launch in background a python server on port 20000, self-hosting the ZIP archives and then build 2 docker images:

* **docker-wine**, with only wine-stable (9.0 at time of writing), .NET 4.8 and initialized as Windows 10
* **docker-wine-msvc**, with the required Visual C++ tools and libraries (cl, link, nmake, rc), the latest Windows 10 SDK, CMake, Conan, Ninja and Wix.

## Usage

After building the final docker image, the working directory in the docker image is set to `/home/wine/.wine/drive_c/` and in the `/home/wine/.wine/drive_c/Tools` folder are stored all the required tools, plus a batch file that can set the 64 bit environment, in the specific:

- /home/wine/.wine/drive_c/x64.bat

It contains all the required Windows paths in Windows-style format (as 'C:\..').

The entrypoint of the Docker Image is set to be a `wine64-entrypoint` bash script that loads the 64bit Windows CMD console that waits for commands.

To start the image and execute a prepared Windows command or script, you **have to** call it with double-double quotes as follows:
```
docker run --rm -it -v HOST_PATH_TO_MOUNT:TARGET_PATH madduci/docker-wine-msvc:17.8-2022 ""YOUR_SCRIPT_IN_TARGET_PATH""

docker run --rm -it madduci/docker-wine-msvc:17.8-2022 ""conan install openssl/3.2.0@""
```

alternatively, to issue interactive commands:

```
docker run --rm -it -v HOST_PATH_TO_MOUNT:TARGET_PATH madduci/docker-wine-msvc:17.8-2022
C:>cl /?
C:>conan --version
C:>cmake --version
```

## Caveats

### Encoding

There are small issues when dealing with Windows-1252 encoding, that are unfortunately wine issues. For example, it has been observed that file names with bad encoding cannot be handled in the Windows CMD.

### Visual C++ 

It has been noticed that on some code, the 32 Bit compiler triggers internal compiler errors (like `C1001`), especially when dealing with some Windows-specific header file, such as ATL/MFC related code. The 32 Bit compiler is therefore not enabled. On a 64 Bit build, those problems don't appear and the build works fine. It seems that some compiler flags are also affecting those 32 Bit builds.

### CMake

The *Visual Studio* CMake generator doesn't work, due to issues with MSBuild and wine. CMake can be used only with *NMake Makefiles* or, if you prefer, with *Ninja*, already included in the image. See the `test` project contained in this repository.

In order to work under Wine/CMD, CMake requires the environment variable **MSVC_REDIST_DIR** and that must be transformed in Unix Path format. 

```
set(MSVC_REDIST_DIR $ENV{VCToolsRedistDir})
string(REPLACE  "\\" "/" MSVC_REDIST_DIR "${MSVC_REDIST_DIR}")
```

### Conan 

Conan by default tries to use Visual Studio as generator when used with CMake. 
You have two options: set the environment variable **CONAN_CMAKE_GENERATOR** to "NMake Makefiles" ([see here](https://github.com/conan-io/conan/issues/2388)) or you can run the build step by invoking CMake as follows in your `conanfile.py`:

```
def build(self):
        self.run('cmake -g "{generator}" -DCMAKE_BUILD_TYPE={build_type} {source}'.format(generator="NMake MakeFiles", build_type="Release", source=self.source_folder))
        self.run('cmake --build . ')
        # Builds the installer, if you have set CPACK and WIX in CMake
        self.run('cmake --build . --target package')
```

The extended image comes also with Ninja, so you can speed up your builds by setting "Ninja" as generator, instead of "NMake MakeFiles". This is the default choice, as **CONAN_CMAKE_GENERATOR** is set to "Ninja" in the x64.bat script.

### WIX Toolset

Wix by default attempts to validate the generated MSI setup files and it can return the error LIGHT216.
In case you have an incomplete setup (as in the test folder) or have issues with your Wix/MSI settings, you can pass the `-sval` flag to Wix `light` command in your CPack configuration:

```
# LIGHT216 error while building MSI package under wine
set(CPACK_WIX_LIGHT_EXTRA_FLAGS -sval )
```
