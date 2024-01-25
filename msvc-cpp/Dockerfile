FROM madduci/docker-wine:9-stable as sources

USER root

COPY vagrant/packages/ /home/wine/
ADD https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/MinGit-2.43.0-busybox-64-bit.zip Git.zip

RUN echo "Extracting Visual C++ compiler" \
    && mkdir -p Tools/VS2022 \
    && unzip -d Tools/VS2022/ -q VC2022.zip; \
    echo "Removing telemetry tool VCTIP from VC" \
    && (find Tools/VS2022/ -type f -name 'VCTIP.exe' -exec rm -rf "{}" \; || echo "Done") \
    && echo "Removing LLVM libraries from VC" \
    && (find Tools/VS2022/ -type d -name 'Llvm' -exec rm -rf "{}" \;  || echo "Done") \
    && echo "Removing Hostx86 folder from VC" \
    && (find Tools/VS2022/ -type d -name 'Hostx86' -exec rm -rf "{}" \;  || echo "Done") \
    && echo "Extracting Windows SDK" \
    && mkdir -p Tools/SDK \
    && unzip -d Tools/SDK/ -q SDK.zip; \
    echo "Removing arm libraries from SDK" \
    && (find ./Tools/SDK -type d -name 'arm*' -exec rm -rf "{}" \;  || echo "Done") \
    && echo "Removing old SDK versions" \
    && (find ./Tools/SDK -type d -name '10.0.1[4-6]???.0' -exec rm -rf "{}" \;  || echo "Done") \
    && echo "Extracting CMake" \
    && unzip -d Tools/ -q CMake.zip; \
    echo "Extracting Conan" \
    && unzip -d Tools/ -q Conan.zip; \
    echo "Extracting Ninja" \
    && unzip -d Tools/Ninja -q Ninja.zip; \
    echo "Extracting Wix Toolset" \
    && unzip -d Tools/Wix -q WIX.zip; \
    echo "Extracting Git" \
    && unzip -d Tools/Git -q Git.zip; 

FROM madduci/docker-wine:9-stable

LABEL maintainer="Michele Adduci <adduci@tutanota.com>"

# Set batch script to set 64 Bit environment
COPY --chown=wine:root msvc-cpp/x64.bat /home/wine/.wine/drive_c/x64.bat

# Set an application entrypoint that loads automatically the environment variables
COPY --chown=wine:root msvc-cpp/wine64-entrypoint /usr/local/bin/wine64-entrypoint

# Prepare Conan profile
ADD --chown=wine:root msvc-cpp/.conan2 /home/wine/.wine/drive_c/users/wine/.conan2

WORKDIR /home/wine/.wine/drive_c

COPY --from=sources --chown=wine:root /home/wine/Tools /home/wine/.wine/drive_c/Tools

USER root

RUN echo "Fix Permissions" \
    && chmod +x /usr/local/bin/wine64-entrypoint \
    && chown -R wine:root ./Tools Tools/VS2022 Tools/SDK || echo "Done" \
    && chmod -R 775 ./Tools Tools/VS2022 Tools/SDK || echo "Done" ;

RUN sed -i 's/manager/store/g' /home/wine/.wine/drive_c/Tools/Git/etc/gitconfig
    
USER wine

ENTRYPOINT [ "/usr/local/bin/wine64-entrypoint" ]
