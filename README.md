# Instalación Arch #
Ponemos el teclado en nuestra distribución `loadkeys es `

### Conexión a internet
Accedemos al prompt de iwctl `iwctl`

Listamos los dispositivos para ver la tajeta de red `device list`

Con el nombre del adaptador ejecutamos un scan para ver las conexiones disponibles

`station <device-name> scan`

Este comando no mostrará nada, solo hace el scaneo. Para mostrar las conexiones haremos:

`station <device-name> get-networks`

Una vez tenemos escaneadas las redes nos conectamos utilizando el siguiente comando:

`station <device-name> connect <network-name>`

Una vez ejecutado el comando, nos pedirá la contraseña de la red, la introducimos y ya tenemos acceso a internet.
Salimos del prompt de iwctl con `exit` y hacemos ping a google.com para comprobar que tenemos conexión(`ping google.com`)

#### Sincronizamos reloj

`timedatectl set-ntp true`

### Hacemos las particiones
Abrimos el programa `cfdisk`. Vamos a hacer 3 particiones.(Si ya hay partición EFI)
1. Partición del sistema  Type ==> Linux filesystem pongamos que el device es /dev/sda1
2. Home                        ==> Linux filesystem                           /dev/sda2
3. Swap                        ==> Linux Swap                                 /dev/sda3

Escribimos las particiones

Hacemos `lsblk` para ver la estructura.
Formateamos las particiones (Importante no seguir al pie de la letra estos comandos, las particiones pueden estar en otro sda)
```
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2
mkswap /dev/sda3
swapon /dev/sda3
```
## Montamos los sistemas de ficheros

`mount /dev/sda1 /mnt`
Creamos el directorio home `mkdir /mnt/home`

Montamos el home `mount /dev/sda2 /mnt/home`
Localizamos la partición EFI en nuestro caso digamos que está en /dev/sda4
Creamos un directorio boot `mkdir /mnt/boot`

`mount /dev/sda4 /mnt/boot`

## Empezamos con la instalación

```
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
# Para comprobarlo podemos hacer cat /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc
#Instalamos nano
pacman -S nano
nano /etc/locale.gen
# Descomentamos en_US.UTF-8 UTF-8 y es_ES.UTF-8 UTF-8 y guardamos el archivo
locale-gen
echo "LANG=es_ES.UTF-8" > /etc/locale.conf
echo "KEYMAP=es" > /etc/vconsole.conf
echo "arch" > /etc/hostname
nano /etc/hosts
#Escribimos
127.0.0.1       localhost
::1             localhost
127.0.1.1       arch.localhost arch
# Guardamos y salimos
```
Ponemos contraseña al root `passwd`

### Descargamos Network Manager
```
pacman -S networkmanager
systemctl enable NetworkManager
```
### Instalamos y configuramos Grub
```
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg
```
### Añadimos un usuario
```
useradd -m <nombre-usuario>
passwd <nombre-usuario>
usermod -aD wheel,video,audio,storage <nombre-usuario>
pacman -S sudo
nano /etc/sudoers
# Descomentamos %wheel ALL=(ALL) ALL y guardamos
exit
exit
```
### Demontamos y apagamos
```
umount -R /mnt
shutdown now
```

### Sacamos el usb y volvemos a arrancar
```
nmcli device wifi list
nmcli device wifi connect <nombre-red> password <contraseña>
```
