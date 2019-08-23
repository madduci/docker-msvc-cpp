# docker-msvc-cpp

This is a reproducible Linux-based Dockerfile for cross compiling with MSVC, Conan and CMake, usable as base image for CI style setups.

This requires a zipped package of a real MSVC installation from Windows
(currently only supporting MSVC 2019, tested 16.2), which isn't redistributable.

The MSVC installation can be performed using a Vagrant box and executing the installation of MSVC Community Edition, whose Vagrantfile is included in this repository.

## Requirements

### Hardware 

* Quad-Core CPU, with VT-x/AMD-v
* 8 GByte RAM (16 GByte recommended)
* Enough Disk Space for Vagrant and Docker images (50 GByte recommended)
* Fast internet connection

### Software

* Virtualbox (5.x/6.x)
* Docker 18.06+
* Docker-Compose 1.20+

## Build

To build the docker image, you need to run the following commands:

```
./download-tools.sh
./build-docker-images.sh
```

The first script will start a Vagrant/Virtualbox Virtual Machine with Windows 10, which will execute an unattended installation of Visual C++ tools, together with CMake, Conan and Wix Toolset. Once the installation is completed, the required files will be compressed in ZIP archives.

The second script will launch in background a python server on port 20000, self-hosting the ZIP archives and then build 3 docker images:

* docker-wine, with only wine-stable (4.0 at time of writing), .NET 4.5 and initialized as Windows 10
* docker-msvc, with the required Visual C++ files (cl, link, nmake) and the latest Windows 10 SDK
* docker-msvc-extended, with the above files and CMake, Wix and Conan

## Usage

After building the final docker image, there is a `/home/wine/.wine/drive_c/Tools` folder, containing all the required tools, plus two batch files that can switch between 32 and 64 bit compilers, in the specific 

- /home/wine/.wine/drive_c/Tools/msvcenv_x86.bat
- /home/wine/.wine/drive_c/Tools/msvcenv_x64.bat

They contain Windows paths (as 'C:\\..').

To start the image and execute a prepared Windows batch script, just run it as 

```
docker run --rm -it -v HOST_PATH_TO_MOUNT:TARGET_PATH docker-msvc-extended:16.2-2019 cmd /c YOUR_SCRIPT_IN_TARGET_PATH
```

alternatively, to issue interactive commands, 

```
docker run --rm -it --entrypoint /bin/bash -v HOST_PATH_TO_MOUNT:TARGET_PATH docker-msvc-extended:16.2-2019

# In Bash
$.wine/drive_c> wine cmd
# In CMD - 64 Bit compiler
C:>C:\Tools\msvcenv_x64.bat 
# In CMD - 32 Bit compiler
C:>C:\Tools\msvcenv_x86.bat 
C:>cl /?
C:>conan --version
C:>cmake --version
```

## Caveats

### CMake

The *Visual Studio* CMake generator doesn't work, due to issues with MSBuild 16.0 and wine. CMake can be used only with *NMake Makefiles*. See the test project contained in this repository.

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

### WIX Toolset

Wix by default attempts to validate the generated MSI setup files and it can return the error LIGHT216.
In case you have an incomplete setup (as in the test folder) or have issues with your Wix/MSI settings, you can pass the `-sval` flag to Wix `light` command in your CPack configuration:

```
# LIGHT216 error while building MSI package under wine
set(CPACK_WIX_LIGHT_EXTRA_FLAGS -sval )
```
