# 🌟 XREFS0 VNC Desktop Environment 🌟

Welcome to the **XREFS0** custom Ubuntu Docker environment. This project provides a fully-fledged, browser-based Linux desktop tailored with a Windows 10 aesthetic, custom tools, and automated optimizations.

## 🚀 Features
- **Windows 10 Theme & Icons:** Fully styled XFCE desktop environment to look like Windows.
- **Web-based Access:** Connect instantly via browser using noVNC with Auto-connect & Auto-scale.
- **Optimized & Secure:** Runs securely as the `XREFS0` user.
- **Pre-installed Tools:** Firefox, VLC, Python, PDF Reader, Archive tools, and more!
- **Clipboard Sync:** Seamless copy/paste between host and container.
- **Arabic Support:** Full Arabic fonts and `Alt+Shift` keyboard layout switching.

## 🛠️ How to Use

1. **Build the Docker Image:**
   ```bash
   docker build -t xrefs0-desktop .
   ```

2. **Run the Container:**
   ```bash
   docker run -d -p 6080:6080 -p 5901:5901 xrefs0-desktop
   ```

3. **Access the Desktop:**
   Open your browser and navigate to: [http://localhost:6080](http://localhost:6080)
   
   *(VNC Password: `123`)*

---

## 📬 Connect with XREFS0

Feel free to reach out or follow for more updates:

<div align="center">

[![Website](https://img.shields.io/badge/Website-000000?style=for-the-badge&logo=google-chrome&logoColor=white)](http://xrefs0.com/)
[![Facebook](https://img.shields.io/badge/Facebook-%231877F2.svg?style=for-the-badge&logo=Facebook&logoColor=white)](https://www.facebook.com/XREFS0)
[![YouTube](https://img.shields.io/badge/YouTube-%23FF0000.svg?style=for-the-badge&logo=YouTube&logoColor=white)](https://www.youtube.com/@XREFS0)
[![Telegram Contact](https://img.shields.io/badge/Telegram_Contact-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/MrMasaOfficial)
[![Telegram Channel](https://img.shields.io/badge/Telegram_Channel-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/XREFS0_CHANNEL)

</div>
