#!/bin/bash

#######################
#    ^...^  `^...^´   #
#   / o,o \ / O,O \   #
#   |):::(| |):::(|   #
# ====" "=====" "==== #
#         TdC         #
#      1998-2026      #
#######################
# Toca das Corujas
# Códigos Binários,
# Funções de Onda e
# Teoria do Orbital Molecular Inc.
# Unidade Barão Geraldo CX

# 2025_06_22_01_00_28
# 2026_07_03_20_22_51

#######
# Script de criação de uma remaster XTDC
#
# Ícones baseados no pacote Win2-7 https://www.gnome-look.org/p/1012465
# Fontes MS extraídas diretamente de instalações Win10
# Vários lançadores ocultos do menu do painel, permanecendo disponíveis em /usr/share/applications
# Configurações diversas via diretório /etc/skel extraídas e revisadas de outras instalações XTDC
#######

#PREPARAÇÃO


#LISTA DE PPAS DOS PROGRAMAS UTILIZADOS
xtdc_ppa(){
xtdc_ppas=(
afelinczak/ppa #cliptit
cubic-wizard/release
eugenesan/ppa #dupeguru
geany-dev/ppa
inkscape.dev/stable
maarten-baert/simplescreenrecorder
mordec13/youtubedl-gui #yt_downloader
otto-kesselgulasch/gimp
rvm/smplayer
ubuntu-x-swat/updates #mesa, drivers gráficos
webupd8team/y-ppa-manager
)

for ppa in "${xtdc_ppas[@]}"
do
add-apt-repository -y ppa:"$ppa"
done

#LIMPA SOURCES.LIST
sed -i.bkp -e '/^\s*#.*$/d' -e '/^\s*$/d' /etc/apt/sources.list
sort /etc/apt/sources.list  uniq -u
apt-get update
}

#LISTA DOS PROGRAMAS
xtdc_pkg(){
sudo apt-get update
#O CURL É INSTALADO PRIMEIRO PARA PODERMOS INSTALAR O RCLONE VIA SCRIPT
sudo apt-get install -y curl
curl https://rclone.org/install.sh | sudo bash

xtdc_pkgs=(
#INTERNET 
rclone-browser
transmission
#MULTIMIDIA
audacity
smplayer
simplescreenrecorder
#GRAFICOS
eog
shotwell
#ACESSÓRIOS
baobab
clipit
file-roller
#SISTEMA
bleachbit
catfish
evince
geany
gnome-disk-utility
gnome-system-monitor
gnome-system-tools
menulibre
p7zip-full
rar
speedcrunch
synaptic
thunar-archive-plugin
tree
unrar
xfpanel-switch
zenity
#IDIOMA
language-pack-gnome-pt
language-pack-gnome-pt-base
language-pack-pt
language-pack-pt-base
#OUTROS
fusesmb
gvfs-backends
gvfs-fuse
python3-pip
samba-libs
xclip
wmctrl
)

for pkg in "${xtdc_pkgs[@]}"
do
sudo apt install -y "$pkg" --no-install-recommends
done
}


#FERRAMENTAS EM PYTHON
xtdc_pip(){
pip3 install chat-downloader
pip3 install youtube-comment-downloader
pip3 install ffmpeg-normalize
}

#NAVEGADOR DE INTERNET E EXTENSÕES
xtdc_chrome(){
#INSTALA PPA E CHROME COM AS EXTENSÕES
wget -qO - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list
apt-get update
apt-get install -y google-chrome-stable --no-install-recommends
}

xtdc_chrome_ext(){
mkdir -m 777 /opt/google/chrome/extensions

exts=(
#Adblock Plus - bloqueador de anúncios grátis
cfhdojbkjhnklbpkdaibdccddilifddb
#Os anúncios bloqueados para Youtube
cmedhionkhpnakcndndgjdbohmhepckk
#Enhancer for YouTube™ - Configurações especiais para Youtube
ponfpcnoihfmfllpaingbgckeeldkhle
#Downloads
jfchnphgogjhineanplmfkofljiagjfb
#Google Tradutor
aapbdbdomjkkjkaonfhkkikfgjllcleb
#minerBlock
emikbbbebcdfohonlaifafnoanocnebl
#Editor do Office
gbkeegbaiigmenfmjfclcdgdpimamgkj
#SponsorBlock para YouTube - Pule patrocínios
mnjggcdmjocbbbhaepdhchncahnbgone
#Youtube-shorts block
jiaopdjbehhjgokpphdfgmapkobbnmjp
)

for ext in "${exts[@]}"
do
cat <<EOF > /opt/google/chrome/extensions/$ext.json
{
  "external_update_url": "https://clients2.google.com/service/update2/crx"
}
EOF

done
}

xtdc_brave(){
sudo apt install -y apt-transport-https --no-install-recommends
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-browser --no-install-recommends
}


#REMOVE PROGRAMAS DESNECESSÁRIOS
xtdc_limpa_pkg(){
remover=(
apport
apport-symptoms
yelp
yelp-xsl
snapd
aspell
)
for removidos in "${remover[@]}"
do
apt-get purge -y "$removidos"
done

apt-get autoremove
apt-get autoclean
rm -rf /var/cache/apt/archives/*.deb
}

#LIMPA ATALHOS DO MENU DE PROGRAMAS
xtdc_ata_bkp(){
mkdir -m 777 /xtdc2022/ata_BKP
atalhos=(/usr/share/applications/*.desktop)
for ata in "${atalhos[@]}"
do
cp "$ata" /xtdc2022/ata_BKP
done
}


#LIMPA ATALHOS DO MENU DE PROGRAMAS
xtdc_limpa_atalhos(){
rm -rf /usr/share/xubuntu/applications/xfhelp4.desktop

atalhos=(/usr/share/applications/*.desktop)
for ata in "${atalhos[@]}"
do
#ESCONDE TODOS OS ATALHOS
sed -i "$ { s/^.*$/&\n\NoDisplay\=true/ }" "$ata"
#RETIRA TRADUÇÕES
sed -i '/Name\[/d' "$ata"
sed -i '/Comment\[/d' "$ata"
sed -i '/Icon\[/d' "$ata"
sed -i '/Keywords\[/d' "$ata"
sed -i '/GenericName/d' "$ata"
#LIMPA LINHA VAZIAS
sed -i '/^$/d' "$ata"
#LIMPA COMENTÁRIOS
sed -i '/^[[:blank:]]*#/d;s/#.*//' "$ata"
done

}

#CRIA ATALHOS DO MENU DE PROGRAMAS
xtdc_ata(){
#CHROME
cat <<EOF > /usr/share/applications/google-chrome.desktop
[Desktop Entry]
Name=Google Chrome
Comment=Acesse a Internet
Exec=/usr/bin/google-chrome-stable %U
Icon=google-chrome
Terminal=false
Type=Application
Categories=Network
Keywords=navegador;web;

[Desktop Action new-window]
Name=Nova janela
Exec=/usr/bin/google-chrome-stable

[Desktop Action new-private-window]
Name=Nova janela anônima
Exec=/usr/bin/google-chrome-stable --incognito
EOF

cat <<EOF > /usr/share/applications/google-chrome-incognito.desktop
[Desktop Entry]
Name=Google Chrome ANÔNIMO
Comment=Navegar na internet sem deixar rastros
Exec=/usr/bin/google-chrome-stable --incognito
Icon=/usr/share/icons/xtdc_icons/apps/google-chrome-incognito.svg
Terminal=false
Type=Application
Categories=Network;
EOF

#BRAVE
cat <<EOF > /usr/share/applications/brave-browser.desktop
[Desktop Entry]
Version=1.0
Name=Navegador Brave
Comment=Acesse a Internet
Exec=/usr/bin/brave-browser-stable %U
Icon=brave-browser
Terminal=false
Type=Application
Categories=Network;

[Desktop Action new-window]
Name=Nova Janela
Exec=/usr/bin/brave-browser-stable

[Desktop Action new-private-window]
Name=Brave ANÔNIMO
Exec=/usr/bin/brave-browser-stable --incognito
Icon=/usr/share/icons/xtdc_icons/apps/google-chrome-incognito.svg
EOF

#RCLONE BROWSER
cat <<EOF > /usr/share/applications/rclone-browser.desktop
[Desktop Entry]
Name=Rclone Browser
Comment=Gerenciador de contas Dropbox, Google Drive
Exec=/usr/bin/rclone-browser
Icon=rclone-browser.png
Terminal=false
Type=Application
Categories=Network
Keywords=nuvem;drive;
EOF

#TRANSMISSION
cat <<EOF > /usr/share/applications/transmission-gtk.desktop
[Desktop Entry]
Name=Transmission
Comment=Cliente BitTorrent
Exec=transmission-gtk %U
Icon=transmission
Terminal=false
Type=Application
Categories=Network
Keywords=torrent;
EOF

#MULTIMIDIA#############################################################
#SMPLAYER
cat <<EOF > /usr/share/applications/smplayer.desktop
[Desktop Entry]
Name=SMPlayer
Comment=Player de vídeo e música
Exec=smplayer %U
Icon=smplayer
Terminal=false
Type=Application
Categories=AudioVideo
MimeType=audio/ac3;audio/mp4;audio/mpeg;audio/vnd.rn-realaudio;audio/vorbis;audio/x-adpcm;audio/x-matroska;audio/x-mp2;audio/x-mp3;audio/x-ms-wma;audio/x-vorbis;audio/x-wav;audio/mpegurl;audio/x-mpegurl;audio/x-pn-realaudio;audio/x-scpls;audio/aac;audio/flac;audio/ogg;video/avi;video/mp4;video/flv;video/mpeg;video/quicktime;video/vnd.rn-realvideo;video/x-matroska;video/x-ms-asf;video/x-msvideo;video/x-ms-wmv;video/x-ogm+ogg;video/x-theora;video/webm;
Keywords=video;audio;mp3;filme;
EOF

#SIMPLESCREENRECORDER
cat <<EOF > /usr/share/applications/simplescreenrecorder.desktop
[Desktop Entry]
Name=Gravador da área de trabalho
Comment=Grave sua área de trabalho
Exec=simplescreenrecorder --logfile
Icon=simplescreenrecorder
Type=Application
Terminal=false
Categories=AudioVideo;
EOF

#VOLUME
cat <<EOF > /usr/share/applications/pavucontrol.desktop
[Desktop Entry]
Name=Controle de Volume
Comment=Controle de Volume
Exec=pavucontrol
Icon=multimedia-volume-control
Type=Application
Terminal=false
Categories=AudioVideo;
EOF

cat <<EOF > /usr/share/applications/audacity.desktop
[Desktop Entry]
Name=Audacity
Comment=Editor de áudio
Exec=audacity %F
Icon=audacity
Type=Application
Terminal=false
Categories=AudioVideo;
Keywords=audio;sound;alsa;jack;editor;
MimeType=application/x-audacity-project;audio/aac;audio/ac3;audio/mp4;audio/x-ms-wma;video/mpeg;audio/flac;audio/x-flac;audio/mpeg;audio/basic;audio/x-aiff;audio/x-wav;application/ogg;audio/x-vorbis+ogg;
EOF

#ESCRITÓRIO#############################################################
#EVINCE PDF
cat <<EOF > /usr/share/applications/evince.desktop
[Desktop Entry]
Name=Visualizador de documentos PDF
Comment=Visualizador de documentos PDF
Exec=evince %U
Icon=evince
Terminal=false
Type=Application
Categories=Office
MimeType=application/pdf;application/x-bzpdf;application/x-gzpdf;application/x-xzpdf;application/x-ext-pdf;application/postscript;application/x-bzpostscript;application/x-gzpostscript;image/x-eps;image/x-bzeps;image/x-gzeps;application/x-ext-ps;application/x-ext-eps;application/illustrator;application/x-dvi;application/x-bzdvi;application/x-gzdvi;application/x-ext-dvi;image/vnd.djvu+multipage;application/x-ext-djv;application/x-ext-djvu;image/tiff;application/x-cbr;application/x-cbz;application/x-cb7;application/x-cbt;application/x-ext-cbr;application/x-ext-cbz;application/vnd.comicbook+zip;application/x-ext-cb7;application/x-ext-cbt;application/oxps;application/vnd.ms-xpsdocument;
EOF

#GEANY
cat <<EOF > /usr/share/applications/geany.desktop
[Desktop Entry]
Name=Geany
Comment=Editor de texto simples (Bloco de Notas)
Exec=geany %F
Icon=geany
Terminal=false
Type=Application
Categories=Office
MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;text/x-java;text/x-dsrc;text/x-pascal;text/x-perl;text/x-python;application/x-php;application/x-httpd-php3;application/x-httpd-php4;application/x-httpd-php5;application/xml;text/html;text/css;text/x-sql;text/x-diff;
EOF

#GRÁFICOS###############################################################
#VISUALIZADOR DE IMAGENS
cat <<EOF > /usr/share/applications/eog.desktop
[Desktop Entry]
Name=Visualizador de imagens
Comment=Visualizador de imagens
Exec=eog %U
Icon=eog
Terminal=false
Type=Application
Categories=Graphics
MimeType=image/bmp;image/gif;image/jpeg;image/jpg;image/pjpeg;image/png;image/tiff;image/x-bmp;image/x-gray;image/x-icb;image/x-ico;image/x-png;image/x-portable-anymap;image/x-portable-bitmap;image/x-portable-graymap;image/x-portable-pixmap;image/x-xbitmap;image/x-xpixmap;image/x-pcx;image/svg+xml;image/svg+xml-compressed;image/vnd.wap.wbmp;
EOF

#SHOTWELL
cat <<EOF > /usr/share/applications/shotwell.desktop
[Desktop Entry]
Name=Gerenciador de fotos
Comment=Gerencia suas fotos, álbuns, etiquetas
Exec=shotwell %U
Icon=shotwell
Terminal=false
Type=Application
Categories=Graphics;
MimeType=x-content/image-dcf;
EOF

#ACESSÓRIOS#############################################################
#THUNAR
cat <<EOF > /usr/share/applications/thunar.desktop
[Desktop Entry]
Name=Gerenciador de Arquivos
Comment=Gerenciador de Arquivos (Explorer)
Exec=thunar %F
Icon=thunar
Terminal=false
Type=Application
Categories=Utility;
EOF

#BLEACHBIT
cat <<EOF > /usr/share/applications/bleachbit.desktop
[Desktop Entry]
Name=Limpeza do sistema
Comment=Limpeza do sistema
Exec=bleachbit
Icon=bleachbit
Terminal=false
Type=Application
Categories=System;
EOF

#BLEACHBIT ROOT
cat <<EOF > /usr/share/applications/bleachbit-root.desktop
[Desktop Entry]
Name=Limpeza do sistema (como ROOT)
Comment=Limpeza do sistema (como ROOT)
Exec=pkexec bleachbit
Icon=bleachbit
Terminal=false
Type=Application
Categories=System;
EOF

#CALCULADORA
cat <<EOF > /usr/share/applications/speedcrunch.desktop
[Desktop Entry]
Name=Calculadora
Comment=Calculadora
Exec=speedcrunch
Icon=speedcrunch
Terminal=false
Type=Application
Categories=Utility;
EOF

#CATFISH
cat <<EOF > /usr/share/applications/org.xfce.Catfish.desktop
[Desktop Entry]
Name=Buscar Arquivos
Comment=Buscar Arquivos
Exec=/usr/bin/catfish %f
Icon=catfish
Terminal=false
Type=Application
Categories=Utility;
MimeType=inode/directory;
EOF

#TERMINAL
cat <<EOF > /usr/share/applications/xfce4-terminal.desktop
[Desktop Entry]
Name=Terminal
Comment=Usar a linha de comando
Exec=xfce4-terminal
Icon=utilities-terminal
Terminal=false
Type=Application
Categories=Utility;
EOF

#ZIPS
cat <<EOF > /usr/share/applications/file-roller.desktop
[Desktop Entry]
Name=Gerenciador de arquivos compactados (Winzip)
Comment=Gerenciador de arquivos zip, rar, 7z
Exec=file-roller %U
Icon=file-roller
Terminal=false
Type=Application
Categories=Utility;
MimeType=application/bzip2;application/gzip;application/vnd.android.package-archive;application/vnd.ms-cab-compressed;application/vnd.debian.binary-package;application/x-7z-compressed;application/x-7z-compressed-tar;application/x-ace;application/x-alz;application/x-ar;application/x-archive;application/x-arj;application/x-brotli;application/x-bzip-brotli-tar;application/x-bzip;application/x-bzip-compressed-tar;application/x-bzip1;application/x-bzip1-compressed-tar;application/x-cabinet;application/x-cd-image;application/x-compress;application/x-compressed-tar;application/x-cpio;application/x-chrome-extension;application/x-deb;application/x-ear;application/x-ms-dos-executable;application/x-gtar;application/x-gzip;application/x-gzpostscript;application/x-java-archive;application/x-lha;application/x-lhz;application/x-lrzip;application/x-lrzip-compressed-tar;application/x-lz4;application/x-lzip;application/x-lzip-compressed-tar;application/x-lzma;application/x-lzma-compressed-tar;application/x-lzop;application/x-lz4-compressed-tar;application/x-ms-wim;application/x-rar;application/x-rar-compressed;application/x-rpm;application/x-source-rpm;application/x-rzip;application/x-rzip-compressed-tar;application/x-tar;application/x-tarz;application/x-tzo;application/x-stuffit;application/x-war;application/x-xar;application/x-xz;application/x-xz-compressed-tar;application/x-zip;application/x-zip-compressed;application/x-zstd-compressed-tar;application/x-zoo;application/zip;application/zstd;
EOF

#BAOBAB
cat <<EOF > /usr/share/applications/baobab.desktop
[Desktop Entry]
Name=Analisador de uso de disco
Comment=Verifique o tamanho de pastas e o espaço disponível em disco
Keywords=armazenamento;espaço;limpeza;
Exec=baobab
Icon=baobab
Terminal=false
Type=Application
Categories=Utility;
EOF

cat <<EOF > /usr/share/applications/clipit.desktop
[Desktop Entry]
Name=ClipIt
Comment=Gerenciador de área de transferência
Exec=clipit
Icon=clipit-trayicon-offline
Terminal=false
Type=Application
Categories=Utility;
EOF

#CONFIGURAÇÕES##########################################################
#APARÊNCIA
cat <<EOF > /usr/share/applications/xfce-ui-settings.desktop
[Desktop Entry]
Name=Aparência
Comment=Configuração de ícones e temas
Exec=xfce4-appearance-settings
Icon=preferences-desktop-theme
Terminal=false
Type=Application
Categories=Settings;
EOF

#DRIVERS ADICIONAIS
cat <<EOF > /usr/share/applications/software-properties-drivers.desktop
[Desktop Entry]
Name=Drivers Adicionais
Comment=Drivers Adicionais
Exec=/usr/bin/software-properties-gtk --open-tab=4
Icon=jockey
Terminal=false
Type=Application
Categories=Settings;
EOF

#MONITOR
cat <<EOF > /usr/share/applications/xfce-display-settings.desktop
[Desktop Entry]
Name=Monitor
Comment=Monitor
Exec=xfce4-display-settings
Icon=monitor
Terminal=false
Type=Application
Categories=Settings;
EOF

#EDITOR DE TIPOS DE ARQUIVOS
cat <<EOF > /usr/share/applications/xfce4-mime-settings.desktop
[Desktop Entry]
Name=Editor de tipos de arquivos
Comment=Associe programas com tipos de arquivos
Exec=xfce4-mime-settings
Icon=application-x-executable
Terminal=false
Type=Application
Categories=Settings;
EOF

#MOUSE
cat <<EOF > /usr/share/applications/xfce-mouse-settings.desktop
[Desktop Entry]
Name=Mouse
Comment=Mouse
Exec=xfce4-mouse-settings
Icon=preferences-desktop-peripherals
Terminal=false
Type=Application
Categories=Settings;
EOF

#INICIALIZAÇÃO E SESSÃO
cat <<EOF > /usr/share/applications/xfce-session-settings.desktop
[Desktop Entry]
Name=Inicialização e sessão
Comment=Inicialização e sessão
Exec=xfce4-session-settings
Icon=xfce4-session
Terminal=false
Type=Application
Categories=Settings;
EOF

#TECLADO
cat <<EOF > /usr/share/applications/xfce-keyboard-settings.desktop
[Desktop Entry]
Name=Teclado
Comment=Teclado
Exec=xfce4-keyboard-settings
Icon=preferences-desktop-keyboard
Terminal=false
Type=Application
Categories=Settings;
EOF

#SISTEMA################################################################
#GPARTED
cat <<EOF > /usr/share/applications/gparted.desktop
[Desktop Entry]
Name=GParted
Comment=Editor de partições e discos
Exec=/usr/sbin/gparted %f
Icon=gparted
Terminal=false
Type=Application
Categories=System;
EOF

#USUÁRIOS E GRUPOS
cat <<EOF > /usr/share/applications/users.desktop
[Desktop Entry]
Name=Usuários e grupos
Comment=Adicionar usuários ou grupos
Exec=users-admin
Icon=config-users
Terminal=false
Type=Application
Categories=System;
EOF

#MONITOR DO SISTEMA
cat <<EOF > /usr/share/applications/gnome-system-monitor.desktop
[Desktop Entry]
Name=Monitor do Sistema
Comment=Gerencie programas rodando atualmente
Exec=gnome-system-monitor
Icon=utilities-system-monitor
Terminal=false
Type=Application
Categories=System;
EOF


#REVISÂO ATÉ AQUI







#TIPOS DE ARQUIVOS E PROGRAMAS
cat <<EOF > /usr/share/applications/defaults.list
[Default Applications]
application/csv=google-chrome.desktop
application/excel=google-chrome.desktop
application/msexcel=google-chrome.desktop
application/msword=google-chrome.desktop
application/ogg=smplayer.desktop
application/pdf=evince.desktop
application/postscript=evince.desktop
application/rtf=google-chrome.desktop
application/tab-separated-values=google-chrome.desktop
application/vnd.ms-xpsdocument=evince.desktop
application/vnd.openxmlformats-officedocument.spreadsheetml.sheet=google-chrome.desktop
application/vnd.openxmlformats-officedocument.wordprocessingml.document=google-chrome.desktop
application/vnd.openxmlformats-officedocument.wordprocessingml.document=google-chrome.desktop
application/x-ar=file-roller.desktop
application/x-arj=file-roller.desktop
application/x-bzip-compressed-tar=file-roller.desktop
application/x-bzip=file-roller.desktop
application/x-compressed-tar=file-roller.desktop
application/x-compress=file-roller.desktop
application/x-dos_ms_excel=google-chrome.desktop
application/x-excel=google-chrome.desktop
application/x-extension-m4a=smplayer.desktop
application/x-extension-mp4=smplayer.desktop
application/x-flac=smplayer.desktop
application/x-gtar=file-roller.desktop
application/x-gzip=file-roller.desktop
application/xhtml+xml=google-chrome.desktop
application/xhtml_xml=google-chrome.desktop
application/xls=google-chrome.desktop
application/x-matroska=smplayer.desktop
application/xml=google-chrome.desktop
application/x-mps=google-chrome.desktop
application/x-ms-excel=google-chrome.desktop
application/x-msexcel=google-chrome.desktop
application/x-ogg=smplayer.desktop
application/x-perl=geany.desktop
application/x-rar-compressed=file-roller.desktop
application/x-rar=file-roller.desktop
application/x-tar=file-roller.desktop
application/x-war=file-roller.desktop
application/x-xls=google-chrome.desktop
application/x-zip-compressed=file-roller.desktop
application/x-zip=file-roller.desktop
application/x-zoo=file-roller.desktop
application/zip=file-roller.desktop
audio/3gpp=smplayer.desktop
audio/ac3=smplayer.desktop
audio/basic=smplayer.desktop
audio/flac=smplayer.desktop
audio/midi=smplayer.desktop
audio/mp4=smplayer.desktop
audio/mpeg=smplayer.desktop
audio/mpegurl=smplayer.desktop
audio/ogg=smplayer.desktop
audio/x-ape=smplayer.desktop
audio/x-flac=smplayer.desktop
audio/x-gsm=smplayer.desktop
audio/x-it=smplayer.desktop
audio/x-m4a=smplayer.desktop
audio/x-matroska=smplayer.desktop
audio/x-mod=smplayer.desktop
audio/x-mp3=smplayer.desktop
audio/x-mpeg=smplayer.desktop
audio/x-mpegurl=smplayer.desktop
audio/x-ms-asf=smplayer.desktop
audio/x-ms-asx=smplayer.desktop
audio/x-ms-wax=smplayer.desktop
audio/x-ms-wma=smplayer.desktop
audio/x-musepack=smplayer.desktop
audio/x-pn-aiff=smplayer.desktop
audio/x-pn-au=smplayer.desktop
audio/x-pn-wav=smplayer.desktop
audio/x-pn-windows-acm=smplayer.desktop
audio/x-real-audio=smplayer.desktop
audio/x-realaudio=smplayer.desktop
audio/x-vorbis+ogg=smplayer.desktop
audio/x-vorbis=smplayer.desktop
audio/x-wavpack=smplayer.desktop
audio/x-wav=smplayer.desktop
audio/x-xm=smplayer.desktop
image/bmp=eog.desktop
image/gif=eog.desktop
image/jpeg=eog.desktop
image/jpg=eog.desktop
image/png=eog.desktop
image/x-bmp=eog.desktop
image/x-ico=eog.desktop
image/x-png=eog.desktop
image/x-portable-anymap=eog.desktop
image/x-portable-bitmap=eog.desktop
image/x-portable-graymap=eog.desktop
image/x-portable-pixmap=eog.desktop
image/x-xbitmap=eog.desktop
image/x-xpixmap=eog.desktop
inode/directory=thunar.desktop
multipart/x-zip=file-roller.desktop
text/comma-separated-values=geany.desktop
text/csv=geany.desktop
text/html=google-chrome.desktop;geany.desktop;
text/mathml=geany.desktop
text/plain=geany.desktop
text/richtext=google-chrome.desktop
text/rtf=google-chrome.desktop
text/spreadsheet=google-chrome.desktop
text/tab-separated-values=google-chrome.desktop
text/x-chdr=geany.desktop
text/x-comma-separated-values=google-chrome.desktop
text/x-csrc=geany.desktop
text/x-dtd=geany.desktop
text/xml=geany.desktop
text/x-python=geany.desktop
text/x-sql=geany.desktop
video/3gpp=smplayer.desktop
video/flv=smplayer.desktop
video/mp2t=smplayer.desktop
video/mp4=smplayer.desktop
video/mp4v-es=smplayer.desktop
video/mpeg=smplayer.desktop
video/msvideo=smplayer.desktop
video/ogg=smplayer.desktop
video/quicktime=smplayer.desktop
video/vivo=smplayer.desktop
video/vnd.divx=smplayer.desktop
video/webm=smplayer.desktop
video/x-anim=smplayer.desktop
video/x-avi=smplayer.desktop
video/x-flc=smplayer.desktop
video/x-flic=smplayer.desktop
video/x-fli=smplayer.desktop
video/x-flv=smplayer.desktop
video/x-m4v=smplayer.desktop
video/x-matroska=smplayer.desktop
video/x-mpeg=smplayer.desktop
video/x-ms-asf=smplayer.desktop
video/x-ms-asx=smplayer.desktop
video/x-msvideo=smplayer.desktop
video/x-ms-wm=smplayer.desktop
video/x-ms-wmv=smplayer.desktop
video/x-ms-wmx=smplayer.desktop
video/x-ms-wvx=smplayer.desktop
video/x-nsv=smplayer.desktop
video/x-ogm+ogg=smplayer.desktop
x-content/audio-cdda=smplayer.desktop
x-content/audio-dvd=smplayer.desktop
x-content/audio-player=smplayer.desktop
x-content/image-dcf=shotwell.desktop
x-content/image-picturecd=shotwell.desktop
x-content/video-dvd=smplayer.desktop
x-content/video-svcd=smplayer.desktop
x-content/video-vcd=smplayer.desktop
x-scheme-handler/ftp=google-chrome.desktop
x-scheme-handler/http=google-chrome.desktop
x-scheme-handler/https=google-chrome.desktop
zz-application/zz-winassoc-xls=google-chrome.desktop
EOF


#GOOGLE PLANILHAS
#cat <<EOF > /usr/share/applications/chrome-felcaaldnbdncclmgdcncolpebgiejap-Default.desktop
#[Desktop Entry]
#Terminal=false
#Type=Application
#Name=Planilhas (Excel Online)
#Comment=Editor online de planilhas (Google Planilhas)
#Exec=/opt/google/chrome/google-chrome --profile-directory=Default --app-id=felcaaldnbdncclmgdcncolpebgiejap
#Icon=/usr/share/icons/xtdc_icons/apps/excel.png
#StartupWMClass=crx_felcaaldnbdncclmgdcncolpebgiejap
#Categories=Office;
#Keywords=excel;planilha;xls;
#EOF

#GOOGLE DOCUMENTOS
#cat <<EOF > /usr/share/applications/chrome-aohghmighlieiainnegkcijnfilokake-Default.desktop
#[Desktop Entry]
#Terminal=false
#Type=Application
#Name=Documentos (Word Online)
#Comment=Editor online de documentos (Google Docs)
#Exec=/opt/google/chrome/google-chrome --profile-directory=Default --app-id=aohghmighlieiainnegkcijnfilokake
#Icon=/usr/share/icons/xtdc_icons/apps/word.png
#StartupWMClass=crx_aohghmighlieiainnegkcijnfilokake
#Categories=Office;
#Keywords=word;doc;Text;Editor;
#EOF
#'
}


#CONFIGURAÇÕES VISUAIS
xtdc_tema(){
RAIZ=$PWD
#BAIXANDO PACOTES
cd "$RAIZ" || return
#xtdc_gred http://bit.do/xtdc_icons xtdc_icons.tar.gz;
#xtdc_gred http://bit.do/xtdc_theme xtdc_theme.tar.gz;
#xtdc_gred http://bit.do/xtdc_ttf xtdc_ttf.tar.gz;
#xtdc_gred http://bit.do/xtdc_painel xtdc_painel.tar.gz;
#xtdc_gred http://bit.do/xtdc_skel xtdc_skel.tar.gz;

#ÍCONES
chmod 777 -R /usr/share/icons
tar xf ./xtdc_icons.tar.gz -C /usr/share/icons
cp -f /usr/share/icons/xtdc_icons/meus_icones/xubuntu-logo.png /usr/share/pixmaps/xubuntu-logo.png
cp -f /usr/share/icons/xtdc_icons/meus_icones/xubuntu-logo-menu.png /usr/share/pixmaps/xubuntu-logo-menu.png
cp -f /usr/share/icons/xtdc_icons/meus_icones/xubuntu-logo.svg /usr/share/pixmaps/xubuntu-logo.svg

#TEMA
tar xf ./xtdc_theme.tar.gz -C /usr/share/themes
chmod 777 -R /usr/share/themes

#FONTES TRUE TYPE
chmod 777 -R /usr/share/fonts/truetype
tar xf ./xtdc_ttf.tar.gz -C /usr/share/fonts/truetype

#PAINEL
cp -r ./xtdc_painel.tar.gz /usr/share/xfce4-panel-profiles/layouts/

#SKEL
mv /etc/skel /etc/skel_bkp
tar xf ./xtdc_skel.tar.gz -C /etc

#SEGUNDA COMO PRIMEIRO DIA
sed '/^END LC_TIME.*/i first_weekday 2' -i /usr/share/i18n/locales/pt_BR
#week 7;19971130;2

locale-gen

#APAGA IMAGENS DE FUNDO E COLOCA FUNDO PRETO NA TELA DE LOGIN
rm -rf /usr/share/backgrounds/xfce/*
rm -rf /usr/share/xfce4/backdrops/*

chmod 777 /usr/share/lightdm/lightdm-gtk-greeter.conf.d/01_ubuntu.conf
cat <<EOF > /usr/share/lightdm/lightdm-gtk-greeter.conf.d/01_ubuntu.conf
[greeter]
background=#000000
theme-name=xtdc_theme
icon-theme-name=xtdc_icons
font-name=Ubuntu 11
indicators=~host;~spacer;~session;~language;~a11y;~clock;~power;
clock-format=%d %b, %H:%M
EOF

chmod 777 /usr/share/lightdm/lightdm-gtk-greeter.conf.d/30_xubuntu.conf
cat <<EOF > /usr/share/lightdm/lightdm-gtk-greeter.conf.d/30_xubuntu.conf
[greeter]
background=#000000
theme-name=xtdc_theme
icon-theme-name=xtdc_icons
font-name=Noto Sans 9
keyboard=onboard
screensaver-timeout=60
EOF

#APAGA ARQUIVOS BAIXADOS
#rm -rf "$RAIZ"/*.tar.gz
}

xtdc_exe(){
#ARQUIVO COM FUNÇÕES
#curl -L -o "xtdc" "https://raw.githubusercontent.com/Pinhalito/xtdc22/main/xtdc"
mv xtdc /bin/xtdc
chmod 777 /bin/xtdc
}

#FIM DO SCRIPT
#######################################################################

#"wget -qO xtdc22_install.sh https://raw.githubusercontent.com/Pinhalito/xtdc22/main/xtdc22_install.sh && source xtdc22_install.sh"



#FUNÇÕES ÚTEIS

#xtdc_gred(){
#aberto=$(curl -sIL "$1" 2>&1 | awk '/^Location/ {print $2}' | tail -n1);
#reduzido=$(echo "$aberto" | cut -d'/' -f 6)
#curl -L -o "$2" "https://drive.google.com/uc?export=download&id=""$reduzido"
#wget --no-check-certificate "https://docs.google.com/uc?export=download&id=""$reduzido" -O "$2"
#curl -L -o "$2" "$aberto"
#}


xtdc_funcs(){
clear
vari=$(sed -nr '/\(\)/p' "${BASH_SOURCE[0]}" | sed 's/...$//')
last=$(date -r "${BASH_SOURCE[0]}" "+%Y_%m_%d_%H_%M_%S")
printf "LISTA DE FUNÇÕES XTDC ATUALIZADA EM $last""%s\n"
printf "${vari[*]}""%s\n" 
}

#CHAMADA DE TODAS AS FUNÇÕES A SEREM INSTALADAS
xtdc_install(){
xtdc_ppa && xtdc_pkg && xtdc_pip && xtdc_chrome && xtdc_limpa_pkg && xtdc_limpa_atalhos && xtdc_atalhos && xtdc_tema && xtdc_exe
}
