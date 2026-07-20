FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -y && apt install --no-install-recommends -y xfce4 xfce4-goodies tigervnc-standalone-server novnc websockify sudo xterm init systemd snapd vim net-tools curl wget git tzdata
RUN apt update -y && apt install -y dbus-x11 x11-utils x11-xserver-utils x11-apps
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:mozillateam/ppa -y
RUN echo 'Package: *' >> /etc/apt/preferences.d/mozilla-firefox
RUN echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozilla-firefox
RUN echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/mozilla-firefox
RUN echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:jammy";' | tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
RUN apt update -y && apt install -y firefox
RUN apt update -y && apt install -y xubuntu-icon-theme

# Download custom wallpaper and Windows 10 themes/icons
RUN mkdir -p /usr/share/backgrounds && \
    wget -qO /usr/share/backgrounds/custom_bg.jpg "https://b.top4top.io/p_3853l6za61.jpg" && \
    wget -qO- https://github.com/B00merang-Project/Windows-10/archive/refs/heads/master.tar.gz | tar -xz -C /usr/share/themes/ && \
    mv /usr/share/themes/Windows-10-master /usr/share/themes/Windows-10 && \
    wget -qO- https://github.com/B00merang-Project/Windows-10-Icons/archive/refs/heads/master.tar.gz | tar -xz -C /usr/share/icons/ && \
    mv /usr/share/icons/Windows-10-Icons-master /usr/share/icons/Windows-10-Icons

# Create a startup script to apply the themes and wallpaper
RUN mkdir -p /root/.config/autostart && \
    echo '[Desktop Entry]' > /root/.config/autostart/theme-setup.desktop && \
    echo 'Type=Application' >> /root/.config/autostart/theme-setup.desktop && \
    echo 'Name=Theme Setup' >> /root/.config/autostart/theme-setup.desktop && \
    echo 'Exec=bash -c "sleep 3; xfconf-query -c xfwm4 -p /general/theme -s Windows-10; xfconf-query -c xsettings -p /Net/ThemeName -s Windows-10; xfconf-query -c xsettings -p /Net/IconThemeName -s Windows-10-Icons; for p in \$(xfconf-query -c xfce4-desktop -p /backdrop -l | grep last-image); do xfconf-query -c xfce4-desktop -p \$p -s /usr/share/backgrounds/custom_bg.jpg; done; rm -f /root/.config/autostart/theme-setup.desktop"' >> /root/.config/autostart/theme-setup.desktop && \
    echo 'Hidden=false' >> /root/.config/autostart/theme-setup.desktop && \
    echo 'NoDisplay=false' >> /root/.config/autostart/theme-setup.desktop && \
    echo 'X-GNOME-Autostart-enabled=true' >> /root/.config/autostart/theme-setup.desktop

RUN touch /root/.Xauthority
EXPOSE 5901
EXPOSE 6080
CMD bash -c "vncserver -localhost no -SecurityTypes None -geometry 1024x768 --I-KNOW-THIS-IS-INSECURE && openssl req -new -subj "/C=JP" -x509 -days 365 -nodes -out self.pem -keyout self.pem && websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && tail -f /dev/null"
