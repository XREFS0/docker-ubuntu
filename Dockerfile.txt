FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# ضبط المنطقة الزمنية (القاهرة كمثال، يمكنك تغييرها لاحقاً)
ENV TZ=Africa/Cairo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# تثبيت الحزم الأساسية، الواجهة، الخطوط، أدوات فك الضغط، الصوتيات، البرمجة، والميديا
RUN apt update -y && \
    apt install --no-install-recommends -y \
    xfce4 xfce4-goodies tigervnc-standalone-server novnc websockify \
    sudo xterm init systemd snapd vim net-tools curl wget git tzdata \
    dbus-x11 x11-utils x11-xserver-utils x11-apps \
    fonts-hosny-amiri fonts-kacst fonts-arabeyes \
    unzip zip p7zip-full pulseaudio evince python3 python3-pip \
    xfce4-whiskermenu-plugin autocutsel vlc && \
    apt clean && rm -rf /var/lib/apt/lists/*

# إعداد وتثبيت Firefox بالطريقة التقليدية
RUN apt update -y && apt install software-properties-common -y && \
    add-apt-repository ppa:mozillateam/ppa -y && \
    echo 'Package: *' >> /etc/apt/preferences.d/mozilla-firefox && \
    echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozilla-firefox && \
    echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/mozilla-firefox && \
    echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:jammy";' | tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox && \
    apt update -y && apt install -y firefox xubuntu-icon-theme && \
    apt clean && rm -rf /var/lib/apt/lists/*

# إعداد واجهة noVNC للدخول التلقائي وضبط الشاشة تلقائياً
RUN echo '<meta http-equiv="refresh" content="0; url=vnc.html?autoconnect=true&resize=remote">' > /usr/share/novnc/index.html

# تحميل ثيم وأيقونات ويندوز 10 من Github وفك ضغطها
RUN wget -q https://github.com/B00merang-Project/Windows-10/archive/refs/heads/master.zip -O /tmp/win10-theme.zip && \
    wget -q https://github.com/B00merang-Project/Windows-10-Icons/archive/refs/heads/master.zip -O /tmp/win10-icons.zip && \
    unzip -q /tmp/win10-theme.zip -d /usr/share/themes/ && \
    unzip -q /tmp/win10-icons.zip -d /usr/share/icons/ && \
    rm /tmp/win10-theme.zip /tmp/win10-icons.zip

# إنشاء مستخدم في أوبونتو
RUN useradd -m -s /bin/bash XREFS0 && echo "XREFS0:123" | chpasswd && usermod -aG sudo XREFS0

# إعداد المتغيرات
ENV VNC_PASSWORD=123
ENV RESOLUTION=1280x720
ENV USER=XREFS0
ENV HOME=/home/XREFS0

# التبديل للمستخدم الجديد لتشغيل النظام بأمان
USER XREFS0
WORKDIR /home/XREFS0

# إنشاء المجلدات اللازمة للـ VNC
RUN mkdir -p /home/XREFS0/.vnc && touch /home/XREFS0/.Xauthority

# تحميل اللوجو الخاص بك وإعداد ملف التشغيل (xstartup) لتعيينه كخلفية وتطبيق ثيم ويندوز 10 وإعدادات إضافية
RUN wget -q -O /home/XREFS0/wallpaper.jpg "https://b.top4top.io/p_3853l6za61.jpg" && \
    echo '#!/bin/bash' > /home/XREFS0/.vnc/xstartup && \
    echo 'xrdb $HOME/.Xresources' >> /home/XREFS0/.vnc/xstartup && \
    echo 'autocutsel -fork' >> /home/XREFS0/.vnc/xstartup && \
    echo 'autocutsel -selection PRIMARY -fork' >> /home/XREFS0/.vnc/xstartup && \
    echo '(sleep 5 && \' >> /home/XREFS0/.vnc/xstartup && \
    echo 'setxkbmap -layout us,ar -option "grp:alt_shift_toggle" && \' >> /home/XREFS0/.vnc/xstartup && \
    echo 'xfconf-query -c xsettings -p /Net/ThemeName -n -t string -s "Windows-10-master" && \' >> /home/XREFS0/.vnc/xstartup && \
    echo 'xfconf-query -c xsettings -p /Net/IconThemeName -n -t string -s "Windows-10-Icons-master" && \' >> /home/XREFS0/.vnc/xstartup && \
    echo 'xfconf-query -c xfwm4 -p /general/theme -n -t string -s "Windows-10-master" && \' >> /home/XREFS0/.vnc/xstartup && \
    echo 'xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -n -t string -s /home/XREFS0/wallpaper.jpg && \' >> /home/XREFS0/.vnc/xstartup && \
    echo 'xfconf-query -c xfce4-panel -p /plugins/plugin-1 -s whiskermenu || true \' >> /home/XREFS0/.vnc/xstartup && \
    echo ') &' >> /home/XREFS0/.vnc/xstartup && \
    echo 'exec startxfce4' >> /home/XREFS0/.vnc/xstartup && \
    chmod +x /home/XREFS0/.vnc/xstartup

EXPOSE 5901
EXPOSE 6080

# أمر التشغيل النهائي باستخدام المتغيرات وبصلاحيات المستخدم العادي
CMD bash -c "echo $VNC_PASSWORD | vncpasswd -f > ~/.vnc/passwd && chmod 600 ~/.vnc/passwd && vncserver -localhost no -SecurityTypes VncAuth -PasswordFile ~/.vnc/passwd -geometry $RESOLUTION && openssl req -new -subj \"/C=EG\" -x509 -days 365 -nodes -out ~/self.pem -keyout ~/self.pem && websockify -D --web=/usr/share/novnc/ --cert=~/self.pem 6080 localhost:5901 && tail -f /dev/null"
