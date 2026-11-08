If the theme does not work and in ```sudo journalctl``` you see:

```The theme at "/usr/share/sddm/themes/win7welcome" requires missing "/usr/bin/sddm-greeter" . Using fallback theme.```

Create a symbolic link sddm-greeter to your actual sddm greeter:

```sudo ln -s /usr/bin/sddm-greeter-qt6 /usr/bin/sddm-greeter```