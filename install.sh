#!/bin/bash

#Instalación de todo el software
#Actualizamos el sistema
echo "Actualizando el sistema"
pacman -Syu -y
echo "Instalando software"
pacman -S rofi base-devel firefox alacritty vim ranger binutils -y
echo "Instalamos yay para descargar desde AUR"
cd /opt/
git clone https://aur.archlinux.org/yay-git.git
sudo chown -R kaikie:kaikie ./yay-git
cd yay-git
makepkg -si
yay -S ttf-fantasque-sans-mono
yay -S nerd-fonts-ubuntu-mono
#Instalamos entorno de escritorio
echo "Instalando entorno de escritorio"
pacman -S qtile lightdm xorg-server -y
systemctl enable lightdm
pacman -S lightdm-gtk-greeter -y
pacman -S xterm code feh picom zsh -y
pacman -S xorg-xinit -y
#Cambios permanentes
mv ~/ovdotfiles/.xprofile ~
chmod u+x /~/.xprofile
#Alacritty
mkdir ~/.config/alacritty
mv ~/ovdotfiles/alacritty.yml ~/.config/alacritty
cp -r ~/ovdotfiles/bars ~/.config/qtile 

echo "Configurando qtile"

FICHERO=/~/.config/qtile/autostart.sh

if [ -f $FICHERO ]
then
   echo "El fichero $FICHERO existe"
   echo -e "setxkbmap es /n feh --bg-scale $$$ " >> $FICHERO

else
   echo "No existe la configuración inicial de qtile."
   echo "Reinicie el sistema"
   exit
fi
