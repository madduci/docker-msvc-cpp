FROM docker-wine:5.0-stable

# Set batch scripts to set 32 or 64 Bit environments
COPY --chown=wine:root x86.bat /home/wine/.wine/drive_c/x86.bat
COPY --chown=wine:root x64.bat /home/wine/.wine/drive_c/x64.bat
# Prepare Conan profile
ADD --chown=wine:root .conan /home/wine/.wine/drive_c/users/wine/.conan

WORKDIR /home/wine/.wine/drive_c

USER root

RUN echo "Extracting Visual C++ compiler" \
    && curl -L http://172.17.0.1:20000/VC2019.zip -o VC.zip \
    && unzip -d Tools/ -q VC.zip ; \
    echo "Extracting Windows SDK" \
    && curl -L http://172.17.0.1:20000/SDK.zip -o SDK.zip \
    && mkdir -p Tools/SDK \
    && unzip -d Tools/SDK/ -q SDK.zip ; \
    echo "Extracting CMake" \
    && curl -L http://172.17.0.1:20000/CMake.zip -o CMake.zip \
    && unzip -d Tools/ -q CMake.zip ; \
    echo "Extracting Conan" \
    && curl -L http://172.17.0.1:20000/Conan.zip -o Conan.zip \
    && unzip -d Tools/ -q Conan.zip ; \
    echo "Extracting Ninja" \
    && curl -L http://172.17.0.1:20000/Ninja.zip -o Ninja.zip \
    && unzip -d Tools/Ninja -q Ninja.zip ; \
    echo "Extracting Wix Toolset" \
    && curl -L http://172.17.0.1:20000/WIX.zip -o WIX.zip \
    && unzip -d Tools/Wix -q WIX.zip ; \
    echo "Fix Permissions" \
    && chown -R wine:root ./Tools \
    && chmod -R 775 ./Tools ; \
    echo "Removing telemetry tool VCTIP from VC" \
    && find ./Tools/VC -type f -name 'VCTIP.exe' -exec rm -rf "{}" +; \
    echo "Removing LLVM libraries from VC" \
    && find ./Tools/VC -type d -name 'Llvm' -exec rm -rf "{}" +; \
    echo "Removing Hostx86 folder from VC" \
    && find ./Tools/VC -type d -name 'Hostx86' -exec rm -rf "{}" +; \
    echo "Removing arm libraries from SDK" \
    && find ./Tools/SDK -type d -name 'arm*' -exec rm -rf "{}" +; \
    echo "Removing old SDK versions" \
    && find ./Tools/SDK -type d -name '10.0.1[4-6]???.0' -exec rm -rf "{}" +; \
    echo "Remove downloaded packages" \
    && rm -rf *.zip

USER wine