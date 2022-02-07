#!/bin/bash

#Instalación de todo el software
#Actualizamos el sistema
echo "Actualizando el sistema"
pacman -Syu -y
echo "Instalando software"
pacman -S rofi base-devel firefox alacritty vim ranger -y
echo "Instalamos yay para descargar desde AUR"
cd /opt/
git clone https://aur.archlinux.org/yay-git.git
sudo chown -R kaikie:kaikie ./yay-git
cd yay-git
makepkg -si
yay -S ttf-fantasque-sans-mono
#Instalamos entorno de escritorio
echo "Instalando entorno de escritorio"
pacman -S qtile lightdm xorg-server -y
systemctl enable lightdm
pacman -S lightdm-gtk-greeter -y
pacman -S xterm code feh picom fish -y
pacman -S xorg-xinit -y
#Cambios permanentes
mv home/kaikie/ovdotfiles/.xprofile /home/kaikie/
chmod u+x /home/kaikie/.xprofile
#Alacritty
mkdir /home/kaikie/.config/alacritty
mv home/kaikie/ovdotfiles/alacritty.yml /home/kaikie/.config/alacritty

echo "Configurando qtile"

FICHERO=/home/kaikie/.config/qtile/autostart.sh

if [ -f $FICHERO ]
then
   echo "El fichero $FICHERO existe"
   echo -e "setxkbmap es /n feh --bg-scale $$$ " >> $FICHERO

else
   echo "No existe la configuración inicial de qtile."
   echo "Reinicie el sistema"
   exit
fi
