sudo apt-get install gdebi-core --yes --force-yes
sudo apt-get install libapparmor1 --yes --force-yes
wget http://download2.rstudio.org/rstudio-server-0.98.507-amd64.deb
sudo gdebi rstudio-server-0.98.507-amd64.deb --non-interactive
adduser jim --disabled-password --gecos ""
echo "jim:bob"|chpasswd
