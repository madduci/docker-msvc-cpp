FROM ubuntu:18.04

ENV WINEARCH=win64 \
    WINEDEBUG=-all,err \ 
    DISPLAY=:0.0 \
    WINE_MONO_VERSION=4.9.4 \
    WINE_GECKO_VERSION=2.4.7

RUN export DEBIAN_FRONTEND="noninteractive" \
    && echo "Configuring Ubuntu mirrors with German country code and required tools for Wine" \
    && sed -i -e 's/http:\/\/archive/http:\/\/de.archive/' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y \
        gnupg2 \
        ca-certificates \
        curl \
        p7zip \
        unzip \
        zenity \
        cabextract \
        binutils \
        winbind \
    && echo "Configuring WineHQ mirror" \
    && curl -L https://dl.winehq.org/wine-builds/winehq.key -o /etc/apt/winehq.key \
    && apt-key add /etc/apt/winehq.key \
    && echo "deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main" >> /etc/apt/sources.list \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y \
        winehq-stable \
    && echo "Download winetricks" \
    && curl -L https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -o /usr/local/bin/winetricks \
    && chmod +rx /usr/local/bin/winetricks \
    && echo "Cleaning system" \
    && apt-get autoclean \
    && apt-get clean \
    && apt-get autoremove --purge \
    && rm -rf /var/apt/cache/* \
    && rm -rf /tmp/*  \
    && echo "Creating wine user" \
    && mkdir -p /home/wine \
    && useradd --system -d /home/wine --shell /bin/bash --uid 1000 --gid root wine \
    && chown -R wine /home/wine

USER wine

WORKDIR /home/wine

RUN echo "Download wine extension packages for user" \
    && mkdir -p /home/wine/.cache/wine \
    && curl -L https://dl.winehq.org/wine/wine-mono/${WINE_MONO_VERSION}/wine-mono-${WINE_MONO_VERSION}.msi \
        -o /home/wine/.cache/wine/wine-mono-${WINE_MONO_VERSION}.msi \
    && curl -L https://dl.winehq.org/wine/wine-gecko/${WINE_GECKO_VERSION}/wine_gecko-${WINE_GECKO_VERSION}-x86.msi \
        -o /home/wine/.cache/wine/wine_gecko-${WINE_GECKO_VERSION}-x86.msi \
    && curl -L https://dl.winehq.org/wine/wine-gecko/${WINE_GECKO_VERSION}/wine_gecko-${WINE_GECKO_VERSION}-x86_64.msi \
        -o /home/wine/.cache/wine/wine_gecko-${WINE_GECKO_VERSION}-x86_64.msi \
    && echo "Initializing the wine environment for the current user" \
    && wine wineboot --init \
    && while pgrep wineserver > /dev/null; do sleep 1; done \
    && echo "Installing .NET 4.5 and setting Windows 10 as target" \
    && winetricks --unattended dotnet45 \
    && winetricks --unattended win10 \
    && echo "Deleting cache files" \
    && rm -rf /home/wine/.cache

ENTRYPOINT [ "/bin/bash", "-c", "wine64 cmd" ]