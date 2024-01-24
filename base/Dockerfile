FROM ubuntu:22.04

LABEL maintainer="Michele Adduci <adduci@tutanota.com>"

ENV WINEARCH=win64 \
    WINEDEBUG=-all,err \ 
    DISPLAY=:0.0 \
    WINETRICKS_VERSION=20240105

RUN export DEBIAN_FRONTEND="noninteractive" \
    && echo "Configuring Ubuntu with equired tools for Wine" \
    && apt-get update \
    && apt-get install -y \
        gnupg2 \
        ca-certificates \
        curl \
        p7zip \
        unzip \
        xz-utils \
        zenity \
        cabextract \
        binutils \
        winbind \
    && echo "Configuring WineHQ mirror" \
    && dpkg --add-architecture i386 \
    && curl -L https://dl.winehq.org/wine-builds/winehq.key -o /etc/apt/winehq.key \
    && apt-key add /etc/apt/winehq.key \
    && echo "deb https://dl.winehq.org/wine-builds/ubuntu/ focal main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --install-recommends \
        winehq-stable \
    && echo "Download winetricks" \
    && curl -L https://raw.githubusercontent.com/Winetricks/winetricks/${WINETRICKS_VERSION}/src/winetricks -o /usr/local/bin/winetricks \
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

RUN echo "Initializing the wine environment for the current user" \
    && wine wineboot --init \
    && while pgrep wineserver > /dev/null; do sleep 1; done \
    && winetricks --unattended win10 \
    && echo "Installing .Net 4.8" \
    && winetricks --unattended --force dotnet48 \
    && echo "Deleting cache files" \
    && rm -rf /home/wine/.cache/*

ENTRYPOINT [ "/bin/bash", "-c", "wine64 cmd" ]