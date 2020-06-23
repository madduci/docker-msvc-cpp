FROM madduci/docker-wine:5-stable

LABEL maintainer="Michele Adduci <adduci@tutanota.com>"

# Set batch script to set 64 Bit environment
COPY --chown=wine:root x64.bat /home/wine/.wine/drive_c/x64.bat

# Set an application entrypoint that loads automatically the environment variables
COPY --chown=wine:root wine64-entrypoint /usr/local/bin/wine64-entrypoint

# Prepare Conan profile
ADD --chown=wine:root .conan /home/wine/.wine/drive_c/users/wine/.conan

WORKDIR /home/wine/.wine/drive_c

USER root

RUN echo "Extracting Visual C++ compiler" \
    && curl -L http://172.17.0.1:20000/VC2019.zip -o VC.zip \
    && mkdir -p Tools/VS2019 \
    && unzip -d Tools/VS2019/ -q VC.zip; \
    echo "Removing telemetry tool VCTIP from VC" \
    && (find Tools/VS2019/ -type f -name 'VCTIP.exe' -exec rm -rf "{}" \; || echo "Done") \
    && echo "Removing LLVM libraries from VC" \
    && (find Tools/VS2019/ -type d -name 'Llvm' -exec rm -rf "{}" \;  || echo "Done") \
    && echo "Removing Hostx86 folder from VC" \
    && (find Tools/VS2019/ -type d -name 'Hostx86' -exec rm -rf "{}" \;  || echo "Done") \
    && rm -rf VC.zip \
    && echo "Extracting Windows SDK" \
    && curl -L http://172.17.0.1:20000/SDK.zip -o SDK.zip \
    && mkdir -p Tools/SDK \
    && unzip -d Tools/SDK/ -q SDK.zip; \
    echo "Removing arm libraries from SDK" \
    && (find ./Tools/SDK -type d -name 'arm*' -exec rm -rf "{}" \;  || echo "Done") \
    && echo "Removing old SDK versions" \
    && (find ./Tools/SDK -type d -name '10.0.1[4-6]???.0' -exec rm -rf "{}" \;  || echo "Done") \
    && rm -rf SDK.zip \
    && echo "Extracting CMake" \
    && curl -L http://172.17.0.1:20000/CMake.zip -o CMake.zip \
    && unzip -d Tools/ -q CMake.zip; \
    rm -rf CMake.zip\
    && echo "Extracting Conan" \
    && curl -L http://172.17.0.1:20000/Conan.zip -o Conan.zip \
    && unzip -d Tools/ -q Conan.zip; \
    rm -rf Conan.zip \
    && echo "Extracting Ninja" \
    && curl -L http://172.17.0.1:20000/Ninja.zip -o Ninja.zip \
    && unzip -d Tools/Ninja -q Ninja.zip; \
    rm -rf Ninja.zip \
    && echo "Extracting Wix Toolset" \
    && curl -L http://172.17.0.1:20000/WIX.zip -o WIX.zip \
    && unzip -d Tools/Wix -q WIX.zip; \
    rm -rf WIX.zip \
    && echo "Fix Permissions" \
    && chmod +x /usr/local/bin/wine64-entrypoint \
    && chown -R wine:root ./Tools Tools/VS2019 Tools/SDK || echo "Done" \
    && chmod -R 775 ./Tools Tools/VS2019 Tools/SDK || echo "Done" ;
    
USER wine

ENTRYPOINT [ "/usr/local/bin/wine64-entrypoint" ]
