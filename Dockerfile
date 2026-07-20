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
RUN mkdir -p /usr/share/backgrounds/xfce /usr/share/xfce4/backdrops && \
    wget --no-check-certificate "https://b.top4top.io/p_3853l6za61.jpg" -O /usr/share/backgrounds/custom.jpg && \
    find /usr/share/backgrounds/ /usr/share/xfce4/backdrops/ -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.svg" \) -exec cp /usr/share/backgrounds/custom.jpg {} \;
RUN echo '<meta http-equiv="refresh" content="0; url=vnc.html?autoconnect=true&resize=scale">' > /usr/share/novnc/index.html && \
    echo '<meta http-equiv="refresh" content="0; url=vnc.html?autoconnect=true&resize=scale">' > /usr/share/novnc/vnc_lite.html
RUN touch /root/.Xauthority
EXPOSE 5901
EXPOSE 6080
CMD bash -c "vncserver -localhost no -SecurityTypes None -geometry 1920x1080 --I-KNOW-THIS-IS-INSECURE && openssl req -new -subj "/C=JP" -x509 -days 365 -nodes -out self.pem -keyout self.pem && websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && tail -f /dev/null"
